#!/usr/bin/env perl

use strict;
use warnings;
use diagnostics;

use Local::MusicLibrary;

Local::MusicLibrary::Reader::GetOpt();

while (<>) {
	Local::MusicLibrary::PushSong($_);
}

Local::MusicLibrary::Write();
