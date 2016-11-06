#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use LWP::UserAgent;
use LWP::Protocol::https;
use Data::Dumper;

use Local::Habr;
#use Local::Habr::Parser;

my $ua = LWP::UserAgent->new();

my $res = $ua->get("https://habrahabr.ru/users/kricha");

if ($res->is_success()) {
	my $parser = Local::Habr::Parser->new();
	my $result = $parser->get_user($res->content);
	print Dumper($result);
}

