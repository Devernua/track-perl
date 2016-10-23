package Local::Row;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Row - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
    my ($class, %params) = @_;
    my $self = bless { } => $class;
    $self->{'str'} = $params{'str'};
    return $self;
}

sub get { 
    my ($self, $name, $default) = @_;
    return $self->{'data'}->{$name} || $default;
}

1;
