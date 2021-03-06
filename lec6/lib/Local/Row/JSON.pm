package Local::Row::JSON;
use parent 'Local::Row';

use strict;
use warnings;

use JSON::XS ();

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

my $json = JSON::XS->new();

sub new {
    my ($class, %params) = @_;
    my $self = $class->SUPER::new(%params);
    $self->{'data'} = $json->utf8->decode($self->{'str'});
    return $self;
}


1;
