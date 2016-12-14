package Local::Habr::Printer;

use strict;
use warnings;
use diagnostics;
use Data::Dumper;
use JSON::XS ();

my $json = JSON::XS->new();

sub Print {
	my ($pkg, $data) = @_;
	if($Local::Habr::CFG{"format"} eq "ddp") {
		print Dumper($data);
	}
	elsif($Local::Habr::CFG{"format"} eq "json") {
		print($json->encode($data) . "\n");
	}
	else {
		print Dumper($data);
	}
}