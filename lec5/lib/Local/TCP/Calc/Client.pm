package Local::TCP::Calc::Client;

use 5.010;
use strict;
use warnings;
use diagnostics;
use IO::Socket;
use IO::Select;
use IO::Uncompress::Unzip qw(unzip $UnzipError) ;
use Local::TCP::Calc;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;
	my $server = IO::Socket::INET->new(
		$ip . ":" . $port
	); #or die "Cant connect to server";
	my ($type) = Local::TCP::Calc->read_header($server);
	# read header before read message
	# check on Local::TCP::Calc::TYPE_CONN_ERR();
	return $server;
}

sub do_request {
	my ($pkg, $server, $type, $message) = @_;
	my $pmsg  = Local::TCP::Calc->pack_message($message);
	my $phead = Local::TCP::Calc->pack_header($type, length($pmsg), 1);
	
	print $server $phead;
	print $server $pmsg;

	my ($ptype, $len) 	= Local::TCP::Calc->read_header($server);
	my $struct 			= Local::TCP::Calc->read_message($server, $len);
	
	close $server;
	
	if ($type == Local::TCP::Calc::TYPE_START_WORK()) { 
		return struct; 
	} 
	given($ptype) {
		when(Local::TCP::Calc::STATUS_NEW()  ) { return []}
		when(Local::TCP::Calc::STATUS_WORK() ) { return []}
		when(Local::TCP::Calc::STATUS_DONE() ) { 
			my ($status, $buf);
			($buf, $struct) = ($struct, []); 
			$status = unzip $buf => $struct
       		 	or die "unzip failed: $UnzipError\n";
		}
		when($_ == Local::TCP::Calc::STATUS_ERROR()) { return [];}
		default { print "print "}
	}

	return $struct;
}

1;
