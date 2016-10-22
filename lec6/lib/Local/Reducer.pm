package Local::Reducer;

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
    my ($class, %params) = @_;
    my $self = bless { } => $class;
    $self->{'source'}       = $params{'source'};
    $self->{'row_class'}    = $params{'row_class'};
    $self->{'value'}        = $params{'initial_value'};
    return $self;
}

sub reduced { 
    my ($self) = @_;
    return $self->{'value'};
}

sub reduce_all {
    my ($self) = @_;
    die "error call reduce_all";
}

sub reduce_n {
    my ($self, $n) = @_;
    die "error call reduce_n";
}

1;
