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

sub reduce_all {
    my ($self) = @_;
    while (defined (my $row = $self->{'source'}->next)) {
        my $obj_row = $self->{'row_class'}->new('str' => $row);
        $self->{'value'} += $obj_row->get($self->{'field'}, 0);
    }
    return $self;
}

sub reduce_n {
    my ($self, $n) = @_;
    while ($n-- > 0 defined (my $row = $self->{'source'}->next)) {
        my $obj_row = $self->{'row_class'}->new('str' => $row);
        $self->{'value'} += $obj_row->get($self->{'field'}, 0);
    }
    return $self;
}

1;
