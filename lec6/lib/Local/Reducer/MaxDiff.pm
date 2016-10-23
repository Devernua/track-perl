package Local::Reducer::MaxDiff;
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
    $self->{'top'} = $params{'top'};
    $self->{'bot'} = $params{'bottom'};
    return $self;
}

sub _reduce
{
    my ($self, $row) = @_;
    my $obj_row = $self->{'row_class'}->new('str' => $row);
    my $diff = $obj_row->get($self->{'top'}, 0) - $obj_row->get($self->{'bot'}, 0);
    return ($diff > $self->reduced) ? $diff : $self->reduced; 
}

1;
