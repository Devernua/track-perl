package Local::MusicLibrary::Writer;

use strict;
use warnings;

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
	my @lens = ();
	foreach ( split(",", $Local::MusicLibrary::CFG{"columns"}) ) {
		push @lens, 0;
		
	}
	print "@lens, Hello\n";###


}

1;
