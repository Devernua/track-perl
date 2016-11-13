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
    
    my $parser = HTML::TreeBuilder::XPath->new_from_content($content);
    $data{author} = substr( 
            (
             ($parser->findvalues('//a[ @class = "post-type__value post-type__value_author"]'))[0] or 
             ($parser->findvalues('//a[ @class = "author-info__nickname"]'))[0]
            ), 
            1
    );
    $data{title} = ($parser->findvalues('//h1[ @class = "post__title"]/span'))[-1];
    $data{views} = $parser->findvalue('//div[ @class = "views-count_post"]') =~ s/,/./r;
    $data{stars} = $parser->findvalue('//span[ @class = "favorite-wjt__counter js-favs_count"]') =~ s/,/./r;
    $data{commentors} = [$parser->findvalues('//a[ @class = "comment-item__username"]')];
    return \%data;
}

sub get_user {
	my ($self, $content) = @_;
	my %data;
	
    my $parser = HTML::TreeBuilder::XPath->new_from_content($content);
    $data{nickname} = substr $parser->findvalue('//a[ @class = "author-info__nickname"]'), 1;
    $data{karma} = $parser->findvalue('//div[ @class = "voting-wjt__counter-score js-karma_num"]') =~ s/,/./r;
    $data{rating} = $parser->findvalue('//div[ @class = "statistic__value statistic__value_magenta"]') =~ s/,/./r;
    return \%data;
}

1;
