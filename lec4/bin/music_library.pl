#!/usr/bin/env perl

use strict;
use warnings;
use diagnostics;
use Getopt::Long;

use Local::MusicLibrary;

GetOptions(
        "band:s"    => \$Local::MusicLibrary::CFG{"filters"}{"band"},
        "year:i"    => \$Local::MusicLibrary::CFG{"filters"}{"year"},
        "album:s"   => \$Local::MusicLibrary::CFG{"filters"}{"album"},
        "track:s"   => \$Local::MusicLibrary::CFG{"filters"}{"track"},
        "format:s"  => \$Local::MusicLibrary::CFG{"filters"}{"format"},
        "sort:s"    => \$Local::MusicLibrary::CFG{"sort"},
        "columns:s" => \$Local::MusicLibrary::CFG{"columns"}
    );

while (<>) {
	Local::MusicLibrary::PushSong($_);
}

Local::MusicLibrary::WriteLikeTask();
