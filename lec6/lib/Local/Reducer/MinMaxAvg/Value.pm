package Local::Reducer::MinMaxAvg::Value;

use List::Util qw(max min sum);

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
    my($class, %params) = @_;
    my $self = bless { } => $class;
    $self->{'buff'} = [];
    return $self;
}

sub get_min
{
    $self = shift;
    return min(@{$self->{'buff'}});
}

sub get_max
{
    $self = shift;
    return max(@{$self->{'buff'}});
}

sub get_avg
{
    $self = shift;
    return sum(@{$self->{'buff'}}) / scalar(@{$self->{'buff'}});
}

1;
