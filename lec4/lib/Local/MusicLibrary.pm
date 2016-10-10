package Local::MusicLibrary;

use strict;
use warnings;

use Local::MusicLibrary::Reader;
use Local::MusicLibrary::Writer;
=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

our %CFG = (
	"band" 		=> "",
	"year" 		=> 0,
	"album" 	=> "",
	"track" 	=> "",
	"format" 	=> "",
	"sort" 		=> "",
	"columns" 	=> "band,year,album,track,format"
);

our @SONGS = ();

sub PushSong {
	push @SONGS, Local::MusicLibrary::Reader::GetSong($_);
}

sub Write {
	my @result = @SONGS;
	#filter
	#sort
	#columns
	Local::MusicLibrary::Writer::PrintSongs(@result);
}


1;
