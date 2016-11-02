package Local::TCP::Calc::Server::Queue;

use strict;
use warnings;
use diagnostics;

use Fcntl ':flock';
use Mouse;
use Local::TCP::Calc;

has f_handle       => (is => 'rw', isa => 'FileHandle');
has queue_filename => (is => 'ro', isa => 'Str', default => '/tmp/local_queue.log');
has max_task       => (is => 'rw', isa => 'Int', default => 0);
has curr_id        => (is => 'ro', isa => 'Int', default => 1);

sub init {
	my $self = shift;
	
	# Подготавливаем очередь к первому использованию если это необходимо
}

sub open {
	my $self = shift;
	my $open_type = shift;
	my $lock = shift;
	my $lock_type = shift;

	open(my $f, $open_type, $self->queue_filename) or die "WA $! TA FAAAAA!!!";
	if ($lock) {
		flock($f, $lock_type) or die "Cant flock file $self->cur_task_id";
	}
    $self->f_handle($f);
	# Открваем файл с очередью, не забываем про локи, возвращаем содержимое (перловая структура)
}

sub close {
	my $self = shift;
	#my $struct = shift;
	flock($self->f_handle, LOCK_UN) or die "Cant flock file $self->cur_task_id";;
	close($self->f_handle); 
	# Перезаписываем файл с данными очереди (если требуется), снимаем лок, закрываем файл.
}

sub to_done {
	my $self = shift;
	my $id = shift;
	my $file_name = shift;
	my @que = ();
	$self->open('+<', 1, LOCK_EX);
	my $fields = $self->read();
	unless (defined $fields) {$self->close(); return 0;}
	while (defined $fields) {
		if ($fields->{id} == $id) {
			my $new_fields = {type =>  Local::TCP::Calc::STATUS_DONE(), id => $id, file => $file_name };
			push @que, $new_fields;
		} else {
			push @que, $fields;
		}
		
		$fields = $self->read();
	}

	for (@que) {
		write($_);
	}
	$self->close();
	# Переводим задание в статус DONE, сохраняем имя файла с резуьтатом работы
}

sub to_work {
	my $self = shift;
	my $id = shift;
	my @que = ();
	$self->open('+<', 1, LOCK_EX);
	my $fields = $self->read();
	unless (defined $fields) {$self->close(); return 0;}
	while (defined $fields) {
		if ($fields->{id} == $id) {
			my $new_fields = {type => Local::TCP::Calc::STATUS_WORK(), id => $id, time => 0 };
			push @que, $new_fields;
		} else {
			push @que, $fields;
		}
		
		$fields = $self->read();
	}

	for (@que) {
		write($_);
	}
	$self->close();
}

sub to_error {
	my $self = shift;
	my $id = shift;
	my $file_name = shift;
	#my $error = shift;
	my @que = ();
	$self->open('+<', 1, LOCK_EX);
	my $fields = $self->read();
	unless (defined $fields) {$self->close(); return 0;}
	while (defined $fields) {
		if ($fields->{id} == $id) {
			my $new_fields = {type =>  Local::TCP::Calc::STATUS_ERROR(), id => $id, file => $file_name };
			push @que, $new_fields;
		} else {
			push @que, $fields;
		}
		
		$fields = $self->read();
	}

	for (@que) {
		write($_);
	}
	$self->close();
}

sub get_status {
	my $self = shift;
	my $id = shift;
	$self->open('<', 1, LOCK_SH);
	my $fields = $self->read();
	unless (defined $fields) {$self->close(); return 0;}
	while (defined $fields && $fields->{id} != $id) {
		$fields = $self->read();
	}
	$self->close();
	if ($fields->{id} == $id) {
		my $body = undef;
		if (defined $fields->{file}) {
			$body = $fields->{file};
		}

		return ($fields->{type}, $body);
	}
	return 0;
	# Возвращаем статус задания по id, и в случае DONE или ERROR имя файла с результатом
}

sub delete {
	my $self = shift;
	my $id = shift;
	my $status = shift;
	$self->open('+<', 1, LOCK_EX);
	#read
	$self->close();
	# Удаляем задание из очереди в соответствующем статусе
}

sub get {
	my $self = shift;
	$self->open('<', 1, LOCK_SH);
	my $fields = $self->read();
	unless (defined $fields) {$self->close(); return 0;}
	while (defined $fields && $fields->{type} == Local::TCP::Calc::STATUS_NEW()) {
		$fields = $self->read();
	}
	$self->close();
	if ($fields->{type} == Local::TCP::Calc::STATUS_NEW()) {
		my @tasks = split(',', @{$fields->{tasks}});
		return ($fields->{id}, [@tasks]);
	}
	return 0;
	
	# Возвращаем задание, которое необходимо выполнить (id, tasks)
}

sub add {
	my $self = shift;
	my $new_work = shift;
	my $tasks = join(',', @$new_work);
	$self->open('>>', 1, LOCK_EX);
	my $fields = {type =>  Local::TCP::Calc::STATUS_NEW(), id => $self->curr_id, time => '0', tasks => $tasks };
	$self->write($fields);
	$self->curr_id++;
	$self->close();
	return $self->curr_id - 1;
	# Добавляем новое задание с проверкой, что очередь не переполнилась
}

sub write {
	my $self = shift;
	my $fields = shift;
	for my $key (sort keys %$fields) {
		print($self->f_handle, "$key:" . $fields->{$key} . "\n");
	}
	print "\n";
}

sub read {
	my $self = shift;
	$/="";
	my $fh = $self->f_handle;
	$_ = <$fh>;
	unless (length $_) { return undef; }
	my @fileds =  { split /"([":]+):\s*/m };
	shift @fileds;
	return {(@fileds)};
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
