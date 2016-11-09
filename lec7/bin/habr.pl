#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use LWP::UserAgent;
use Data::Dumper;
use utf8;
use Local::Habr;
use Getopt::Long;

$Local::Habr::CFG{"command"} = $ARGV[0];

GetOptions(
	"site:s" 	=> \$Local::Habr::CFG{"site"},
	"format:s" 	=> \$Local::Habr::CFG{"format"},
	"refresh" 	=> \$Local::Habr::CFG{"refresh"},
	"name:s"	=> \$Local::Habr::CFG{"comhash"}{"name"},
	"post:i"	=> \$Local::Habr::CFG{"comhash"}{"post"},
	"n:i"		=> \$Local::Habr::CFG{"comhash"}{"n"},
	"id:i{1,}"	=> \@{$Local::Habr::CFG{"comhash"}{"id"}},
);

my $ua = LWP::UserAgent->new();

my $res = $ua->get("https://geektimes.ru/users/marks");

if ($res->is_success()) {
	my $parser = Local::Habr::Parser->new();
	my $result = $parser->get_user($res->content);
	print Dumper($result);
}
#$res = $ua->get("https://geektimes.ru/post/145527/");
$res = $ua->get("https://habrahabr.ru/post/314540/");
#$res = $ua->get("https://habrahabr.ru/post/314344");

if ($res->is_success()) {
    my $parser = Local::Habr::Parser->new();
    my $result = $parser->get_post($res->content);
    print Dumper($result);
}
