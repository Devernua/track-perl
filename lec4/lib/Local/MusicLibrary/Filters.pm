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
    my $param = $Local::MusicLibrary::CFG{"sort"};
    unless( defined $param ) { return @_}
    return sort {($param eq "year")? $a->{$param} <=> $b->{$param} : $a->{$param} cmp $b->{$param} } @_;
}

sub _filter
{
    my %curr = %$_;
    my %filters = %{$Local::MusicLibrary::CFG{"filters"}};
    my $result = 1;
    foreach (grep defined $filters{$_}, keys %filters)
    {
        unless( (/year/) ? $curr{$_} == $filters{$_} : $curr{$_} eq $filters{$_} )
        {    
            $result = 0;
        }
    }
    return $result;
}

sub Filter 
{
    return grep _filter($_), @_;
}

42;
