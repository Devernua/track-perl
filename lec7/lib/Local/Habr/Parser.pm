package Local::Habr::Parser;

use strict;
use warnings;
use diagnostics;

use HTML::TokeParser;
use HTML::Entities;
use Data::Dumper;
#use Encode;

=encoding utf8

=head1 NAME

Local::Habr::Parser - base html parser

=head1 VERSION

Version 1.0

=cut 

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
	my ($class, %params) = @_;
	my $self = bless {} => $class;
	return $self;
}

sub get_user {
	my ($self, $content) = @_;
	my %data;
	
	my $parser = HTML::TokeParser->new(\$content);
	
	while (my $token = $parser->get_token()) {
		if (
			$token->[0] eq 'S' && 
			$token->[1] eq 'a' && 
			defined ($token->[2]->{class}) && 
			$token->[2]->{class} =~ /^\s*author\-info__nickname.*/i
		) 
		{
			$data{nickname} =  substr $parser->get_token()->[1], 1;	
		}
		if (
			$token->[0] eq 'S' &&
			$token->[1] eq 'div' &&
			defined ($token->[2]->{class}) &&
			$token->[2]->{class} =~ /^\s*voting\-wjt__counter\-score.*/i
		)
		{
			$data{karma} = $parser->get_token()->[1] =~ s/,/./r;
		}
		if ( 
			$token->[0] eq 'S' &&
			$token->[1] eq 'div' &&
			defined ($token->[2]->{class}) &&
			$token->[2]->{class} =~ /^.*statistic_user\-rating.*/i
		)
		{
			$parser->get_token();
			$parser->get_token();
			$data{rating} = $parser->get_token()->[1] =~ s/,/./r;
		}
	}
	
	return \%data;
	
}

1;
