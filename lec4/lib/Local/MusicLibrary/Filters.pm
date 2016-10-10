package Local::MusicLibrary::Filters;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::MusicLibrary::Filters - filters music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub Select
{
	return grep scalar(@$_),
			map {
			my %curr = %{$_}; 
			[ 
				map 
					$curr{$_}, 
					split ",", $Local::MusicLibrary::CFG{"columns"}
			]
		} 
		@_ ;
}

sub Sort 
{
	return @_;
}

sub Filter 
{
	return @_;
}

42;
