#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use DDP;

my $arr = ([]);

while(<>)
{
    chomp;
    my @F = split(";", $_, 0);
    push($arr, [@F]);
}

print Dumper($arr);
p $arr;
