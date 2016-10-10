package Local::MusicLibrary::Reader;

use strict;
use warnings;

use Getopt::Long;

=encoding utf8

=head1 NAME

Local::MusicLibrary::Reader - read music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub GetOpt
{
	GetOptions(
        "band:s"    => \$Local::MusicLibrary::CFG{band},
        "year:i"    => \$Local::MusicLibrary::CFG{year},
        "album:s"   => \$Local::MusicLibrary::CFG{album},
        "track:s"   => \$Local::MusicLibrary::CFG{track},
        "format:s"  => \$Local::MusicLibrary::CFG{format},
        "sort:s"    => \$Local::MusicLibrary::CFG{sort},
        "columns:s" => \$Local::MusicLibrary::CFG{columns}
    );
}

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
