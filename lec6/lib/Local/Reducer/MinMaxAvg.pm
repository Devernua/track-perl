package Local::Reducer::MinMaxAvg;
use parent 'Local::Reducer';

use Local::Reducer::MinMaxAvg::Value;

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
    my $self = $class->SUPER::new(%params);
    $self->{'field'} = $params{'field'};
    $self->{'value'} = $params{'initial_value'} || 
        Local::Reducer::MinMaxAvg::Value->new();
    return $self;
}

sub _reduce
{
    my ($self, $row) = @_;
    my $obj_row = $self->{'row_class'}->new('str' => $row);
    push (@{$self->{'value'}->{'buff'}}, $obj_row->get($self->{'field'}, undef));
    return $self->{'value'};
}

1;
