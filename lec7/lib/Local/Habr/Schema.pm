package Local::Habr::Schema;
use base qw/DBIx::Class::Schema/;

use strict;
use warnings;
use diagnostics;

=encoding utf8

=head1 NAME

Local::Habr::Schema - base models

=head1 VERSION

Version 1.0

=cut 

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

__PACKAGE__->load_namespaces();

1;