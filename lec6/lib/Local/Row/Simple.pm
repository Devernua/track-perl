package Local::Row::Simple;
use parent 'Local::Row';

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
    $self->{'data'} = {
	map { split ':' } 
        split ',', 
        $self->{'str'}    
    };
    return $self;
}


1;
