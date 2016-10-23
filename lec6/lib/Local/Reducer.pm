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
    $self->{'value'}        = $params{'initial_value'} || 0;
    return $self;
}

sub reduced { 
    my ($self) = @_;
    return $self->{'value'};
}

sub reduce_all {
    my ($self) = @_;
    while (defined (my $row = $self->{'source'}->next)) {
        $self->{'value'} = $self->_reduce($row);
    }
    return $self->reduced();
}

sub reduce_n {
    my ($self, $n) = @_;
    while($n > 0 && defined (my $row = $self->{'source'}->next)) {
        $self->{'value'} = $self->_reduce($row);
        $n--;
    }
    return $self->reduced();
}

1;
