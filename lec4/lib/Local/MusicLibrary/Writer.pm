package Local::MusicLibrary::Writer;

use strict;
use warnings;

use List::Util qw(max sum reduce);

=encoding utf8

=head1 NAME

Local::MusicLibrary::Writer - write music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub PrintSongs
{
    unless(@_) {return 0;}
	
    my @lens = (0) x scalar @{$_[0]};
    @lens = map(max(length $_, shift @lens), @$_) for (@_);

    my @raws = map {
        (reduce { $a .= sprintf("| %$lens[$b]s ", $_->[$b])} "", 0..$#lens ) . "|\n";
    } @_;
    
    print "/" . "-" x ((scalar(@lens) - 1) * 3 + sum(@lens) + 2) . "\\\n";      #head
    print join "|" . join ("+", map("-" x ($_ + 2) , @lens)) . "|\n", @raws;    #content
    print "\\" . "-" x ((scalar(@lens) - 1) * 3 + sum(@lens) + 2) . "/\n";      #footer
}

1;
