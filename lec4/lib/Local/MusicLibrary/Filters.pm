package Local::MusicLibrary::Filters;

use strict;
use warnings;
use List::Util qw(reduce);
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
    my $param = $Local::MusicLibrary::CFG{"sort"};
    unless( defined $param ) { return @_}
    return sort {($param eq "year")? $a->{$param} <=> $b->{$param} : $a->{$param} cmp $b->{$param} } @_;
}


sub Filter 
{
    my %filters = %{$Local::MusicLibrary::CFG{"filters"}};
    return grep {
            not reduce {
                $a += ($b =~ /year/)? $_->{$b} != $filters{$b} : $_->{$b} ne $filters{$b};
            } (0, grep defined $filters{$_}, keys %filters)
        } @_;
}

42;
