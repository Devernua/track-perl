package Local::Habr::Parser;

use strict;
use warnings;
use diagnostics;
use HTML::TreeBuilder::XPath;
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

sub get_post {
    my ($self, $content) = @_;
    my %data;
#my $parser = HTML::TagParser->new($content);
    my $parser = HTML::TreeBuilder::XPath->new_from_content($content);
    $data{author} = substr( 
            (
             ($parser->findvalues('//a[ @class = "post-type__value post-type__value_author"]'))[0] or 
             ($parser->findvalues('//a[ @class = "author-info__nickname"]'))[0]
            ), 
            1
    );
    $data{title} = ($parser->findvalues('//h1[ @class = "post__title"]/span'))[-1];
#$data{author} = substr( ($parser->findvalues('//a[ @class = "author-info__nickname"]'))[0], 1);
#$data{author} = $parser->getElementsByClassName("post-type__value")->innerText;
#$data{author} = substr $parser->getElementsByClassName("post-type__value_author")->innerText, 1;

#$data{title} = $parser->getElementsByClassName("post__title");
#$data{title} = [split("\n", $parser->getElementsByClassName("post__title")->innerText)]->[1] =~ s/^\s+//r;
    return \%data;
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
