package Local::TCP::Calc::Server;

use strict;
use POSIX qw( WNOHANG WIFEXITED );
use IO::Socket;
use Local::TCP::Calc;
use Local::TCP::Calc::Server::Queue;
use Local::TCP::Calc::Server::Worker;

my $max_worker;
my $in_process = 0;

my $pids_master = {};
my $receiver_count = 0;
my $max_forks_per_task = 0;

sub REAPER {
	while ( my $pid = waitpid(-1, WNOHANG) ) {
		last if $pid == -1;
		if( WIFEXITED($?) ) {
			my $status = $? >> 8;
			die "status $status != 0\n" if ($status != 0);
		}
		else { 
			#print "Process $pid sleep $/" 
		} 
	}
};
$SIG{CHLD} = \&REAPER;

sub start_server {
	my ($pkg, $port, %opts) = @_;
	$max_worker         = $opts{max_worker} 		// die "max_worker required"; 
	$max_forks_per_task = $opts{max_forks_per_task} // die "max_forks_per_task required";
	my $max_receiver    = $opts{max_receiver} 		// die "max_receiver required"; 
	
	my $server = IO::Socket::INET->new(
		LocalPort 	=> $port,
		Type 		=> SOCK_STREAM,
		ReuseAddr 	=> 1,
		Listen 		=> $max_receiver,
	) or die "Cant create server";

	my $q = Local::TCP::Calc::Server::Queue->new({max_task => $opts{max_queue_task}});

	while (my $client = $server->accept()) {
		if ($receiver_count >= $max_receiver) { 
			Local::TCP::Calc->send_err($client);
			close $client; 
			next; 
		}

		$receiver_count++;
		my $child = fork();
		if ($child) { 
			$pkg->check_queue_workers($q);
			close $client; next 
		}

		if (defined $child) {
			close $server;
			Local::TCP::Calc->send_ok($client);

			$client->autoflush(1);
			my ($type, $len) 	= Local::TCP::Calc->read_header($client);
			my $struct 			= Local::TCP::Calc->read_message($client, $len);
			
			if ($type == Local::TCP::Calc::TYPE_START_WORK()) {
				my $id 		= $q->add($struct);
				my $pmsg 	= Local::TCP::Calc->pack_message([$id]);
				my $phead 	= Local::TCP::Calc->pack_header($type, length($pmsg), 1);
				print $client $phead;
				print $client $pmsg;
			}
			elsif ($type == Local::TCP::Calc::TYPE_CHECK_WORK()) {
				my ($status, $body) = $q->get_status($struct);
				my $pmsg 	= Local::TCP::Calc->pack_message($body);
				my $phead 	= Local::TCP::Calc->pack_header($status, length($pmsg), 1);
				print $client $phead;
				print $client $pmsg;
			}

			close $client;
			$receiver_count--;
			exit;
		} else {
			Local::TCP::Calc->send_err($client);
			$receiver_count--; 
			#die "Can't fork"; 
		}		
	}
}

sub check_queue_workers {
	my $self = shift;
	my $q = shift;
	if ($in_process >= $max_worker) {return}
	$in_process++;
	my $child = fork();
	if ($child) { 
		return
	}
	if (defined $child) {
		my ($id, $tasks) = $q->get();
		unless (defined $id) { $receiver_count--; exit; }
		$q->to_work($id);

		my $worker = Local::TCP::Calc::Server::Worker->new(
			cur_task_id => $id,
			calc_ref => sub { shift; return eval($_); }, #special for test
			max_forks => $max_forks_per_task,
		);

		my $file = $worker->start($tasks);

		if ($file =~ /error/) {
			$q->to_error($id, $file);
		} else {
			$q->to_done($id, $file);
		}
	
		$receiver_count--;
		exit;
	} else {
		$receiver_count--; 
		#die "Can't fork"; 
	}		
}

1;
