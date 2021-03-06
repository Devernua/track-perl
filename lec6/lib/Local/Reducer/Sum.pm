package Local::Reducer::Sum;
use parent 'Local::Reducer';

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
    return $self;
}

sub _reduce
{  
    my ($self, $row) = @_;
    my $obj_row = $self->{'row_class'}->new('str' => $row);
    return $self->{'value'} + $obj_row->get($self->{'field'}, 0);
}

1;
