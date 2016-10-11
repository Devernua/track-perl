package Local::MusicLibrary::Reader;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::MusicLibrary::Reader - read music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub GetSong
{
	m{
			^
			\.
			/
			(?<band>[^/]+)
			/
			(?<year>\d+)
			\s+ - \s+
			(?<album>[^/]+)
			/
			(?<track>.+)
			\.
			(?<format>[^\.\n]+)
			$
		}x
		or die "[Bad Song] FORMAT: ./band/year - album/track.format";
	
	my %result = %+;
	return \%result;
}

1;
