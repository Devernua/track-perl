package Local::TCP::Calc::Server::Worker;

use strict;
use warnings;
use Mouse;
use Fcntl ':flock';
use POSIX qw( WNOHANG WIFEXITED );

has cur_task_id => (is => 'ro', isa => 'Int', required => 1);
has forks       => (is => 'rw', isa => 'HashRef', default => sub {return {}});
has calc_ref    => (is => 'ro', isa => 'CodeRef', required => 1);
has max_forks   => (is => 'ro', isa => 'Int', required => 1);

sub write_err {
	my $self = shift;
	my $error = shift;
	open (my $fh, '>', "error_" . $self->cur_task_id . ".txt");
	print $fh "$error\n"; 
	# Записываем ошибку возникшую при выполнении задания
}

sub write_res {
	my $self = shift;
	my $res = shift;
	open (my $fh, '>>', "file_" . $self->cur_task_id . ".txt");
	flock($fh, LOCK_EX) or die "Cant flock file $self->cur_task_id";
	print $fh "$res\n"; 
	flock($fh, LOCK_UN) or die "Cant unlock file $self->cur_task_id";
	# Записываем результат выполнения задания
}

sub child_fork {
	my $self = shift;
	my $file = "file_" . $self->cur_task_id . ".txt";
	while ( my $pid = waitpid(-1, WNOHANG) ) {
		last if $pid == -1;
		if( WIFEXITED($?) ) {
			my $status = $? >> 8;
			if ($status != 0) {
				for (values %{$self->forks}) {
					kill 9, $_;
				}
				unlink $file;
				$self->write_err("ANY ERROR");
				#TODO: print error;
				return "error_" . $self->cur_task_id . ".txt";
			}
		}
		else { 
			#print "Process $pid sleep $/" 
		} 
	}
	return $file;
	# Обработка сигнала CHLD, не забываем проверить статус завершения процесс и при надобности убить оставшихся
}

sub start {
	my $self = shift;
	my $task = shift;
	my @tasks = @$task;
	my ($div, $mod) = scalar(@tasks) / $self->max_forks, scalar(@tasks) % $self->max_forks;
	for my $i (0..$self->max_forks) {
		my $len = $div + (($i < $mod) ? 1 : 0);
		next unless $len;
		my @per_task = ();
		push @per_task, shift @tasks for (0..$len);
		my $child = fork();
		if ($child) { 
			$self->forks->{"$i"} = $child;
		}
		if (defined $child) {
			for (@per_task) {
				write_res($_ . " == " . &{$self->calc_ref}($_));
			}		
			exit;
		} else {
			#die "Can't fork"; 
		}
	}
	return $self->child_fork();
	# Начинаем выполнение задания. Форкаемся на нужное кол-во форков для обработки массива примеров
	# Вызов блокирующий, ждём  пока не завершатся все форки
	# В форках записываем результат в файл, не забываем про локи, чтобы форки друг другу не портили результат
	#return file
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
