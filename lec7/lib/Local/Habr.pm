package Local::Habr;

use strict;
use warnings;
use Local::Habr::Parser;
use Local::Habr::Schema;

=encoding utf8

=head1 NAME

Local::Habr - habrahabr.ru crawler

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

our %CFG = (
	"site" 		=> "habrahabr.ru",
	"format" 	=> "ddp",
	"refresh" 	=> undef,
	"command"	=> undef,
	"comhash" 	=> {
			"id" 	=> undef,
			"name" 	=> undef,
			"post" 	=> undef,
			"n"	 	=> undef,
	},	
);

1;
