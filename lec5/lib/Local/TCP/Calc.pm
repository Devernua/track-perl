package Local::TCP::Calc;

our $VERSION = 1.0;

use strict;
use CBOR::XS;

sub TYPE_START_WORK 	{1}
sub TYPE_CHECK_WORK 	{2}
sub TYPE_CONN_ERR   	{3}
sub TYPE_CONN_OK    	{4}

sub STATUS_NEW   	{1}
sub STATUS_WORK  	{2}
sub STATUS_DONE  	{3}
sub STATUS_ERROR 	{4}

sub pack_header {
	my $pkg 	= shift;
	my $type 	= shift;
	my $size 	= shift;
	my $version 	= shift || 1;

	return pack('VVV', $type, $size, $version);
}

sub unpack_header {
	my $pkg 	= shift;
	my $header 	= shift;

	return unpack('VVV', $header);
}

sub pack_message {
	my $pkg 	= shift;
	my $msg 	= shift;
	
	return CBOR::XS::encode_cbor($msg);
}

sub unpack_message {
	my $pkg 	= shift;
	my $msg 	= shift;
	
	return CBOR::XS::decode_cbor($msg);
}

sub my_read {
	my ($pkg, $sock, $len) = @_;
	my ($resp, $l, $buf) = ("", $len);
	do {
		sysread($sock, $buf, $l);
		$resp .= $buf;
		$l -= length($buf);
	} while (length($buf) > 0);
	
	if (length ($resp) != $len) { die "Unexpected connection closing" };
	return $resp;
}

sub send_ok {
	my ($pkg, $sock) = @_;
	print $pkg->pack_header(TYPE_CONN_OK(), 0, 1);
}

sub send_err {
	my ($pkg, $sock) = @_;
	print $pkg->pack_header(TYPE_CONN_ERR(), 0, 1);
}

sub read_header {
	my ($pkg, )
}

sub read_message {
	my ($pkg, )
}
1;
