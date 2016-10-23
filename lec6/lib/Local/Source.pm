package Local::Source;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Source - base abstract source

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
    my ($class, %params) = @_;
    my $self = bless { } => $class;
    return $self;
}

sub next {
    my ($self) = @_;
    shift @{$self->{'iterator'}};
}

1;
