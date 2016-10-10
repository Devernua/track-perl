package Local::MusicLibrary::Writer;

use strict;
use warnings;

use List::Util qw(max sum);

=encoding utf8

=head1 NAME

Local::MusicLibrary::Writer - write music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub PrintSongs
{
	unless(@_) {return 0;}
	my @lens = (0) x scalar @{$_[0]};
	foreach(@_) 
	{
		@lens = map {max(length $_, shift @lens)} @$_;
	}
	print "/" . "-" x ((scalar(@lens) - 1) * 3 + sum(@lens) + 2) . "\\\n"; #head

	print "\\" . "-" x ((scalar(@lens) - 1) * 3 + sum(@lens) + 2) . "/\n"; #footer


}

1;
