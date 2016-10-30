package Local::TCP::Calc::Client;

use strict;
use IO::Socket;
use IO::Select;
use Local::TCP::Calc;

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;
	my $server = IO::Socket::INET->new(
		$ip . ":" . $port
	); #or die "Cant connect to server";
	# read header before read message
	# check on Local::TCP::Calc::TYPE_CONN_ERR();
	return $server;
}

sub do_request {
	my ($pkg, $server, $type, $message) = @_;
	my $pmsg  = Local::TCP::Calc->pack_message({"list" => $message});
	my $phead = Local::TCP::Calc->pack_header($type, length($pmsg), 1);
	
	print $server $phead;
	print $server $pmsg;
	my $struct;
	my $ptype;
	if (IO::Select->new($server)->can_read(2)) {
		$phead = Local::TCP::Calc->my_read($server, 12);
		($ptype, my $len) = Local::TCP::Calc->unpack_header($phead);	
		$pmsg = Local::TCP::Calc->my_read($server, $len);
		$struct = Local::TCP->unpack_message($pmsg);
	}
	
	close $server;
	
	if ($type == Local::TCP::Calc::TYPE_START_WORK()) { return $struct->{'id'}; } 
#	given ($ptype) {
#		when(Local::TCP::Calc::STATUS_NEW) {print "helo"; }
#		when(Local::TCP::Calc::STATUS_WORK) { }
#		when(Local::TCP::Calc::STATUS_DONE) { print "jelo";
#			$struct = $struct->{'file'};
#		}
#		when($_ == Local::TCP::Calc::STATUS_ERROR) { print "eelo";}
#		default { print "print "}
#	}

	return $struct;
}

1;
