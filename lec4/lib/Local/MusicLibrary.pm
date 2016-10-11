package Local::MusicLibrary;

use strict;
use warnings;

use Local::MusicLibrary::Reader;
use Local::MusicLibrary::Writer;
use Local::MusicLibrary::Filters;

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
        "filters" => {
	        "band" 		=> "",
	        "year" 		=> 0,
	        "album" 	=> "",
	        "track" 	=> "",
	        "format" 	=> ""
            },
	    "sort" 		=> "",
	    "columns" 	=> "band,year,album,track,format"
);

our @SONGS = ();

sub PushSong {
	push @SONGS, Local::MusicLibrary::Reader::GetSong($_);
}

sub Write {
	Local::MusicLibrary::Writer::PrintSongs(
		Local::MusicLibrary::Filters::Select
		Local::MusicLibrary::Filters::Sort
		Local::MusicLibrary::Filters::Filter
		@SONGS
	);		

}


1;
