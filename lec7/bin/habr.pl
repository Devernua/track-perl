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

use DBI;

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


my $schema = Local::Habr::Schema->connect("dbi:SQLite:dbname=test.db", "", "");
#$schema->deploy; #for new db

print "Opened database successfully\n";
#my $rs = $schema->resultset('Artist');

#my $new_user = $schema->resultset('User')->new({ nickname => 'Alex', user_id=>2, karma=>0, rating=>3 });
#$new_user->insert; # Auto-increment primary key filled in after INSERT


#my $new_cd = $schema->resultset('CD')->new({ title => 'Spoon' });
#$new_cd->artist($cd->artist);
#$new_cd->insert; # Auto-increment primary key filled in after INSERT
#$new_cd->title('Fork');

#my $johns_rs = $schema->resultset('Artist')->search(
#    # Build your WHERE using an SQL::Abstract structure:
#    { name => "Alex" }
#  );

#my @all_john_cds = $johns_rs->search_related('cds')->all;

#for (@all_john_cds) {
#	print $_->title;
#}
  # Execute a joined query to get the cds.
#  my @all_john_cds = $johns_rs->search_related('cds')->all;

#my $count = 1;
#for (@all_artists) {
#	print $_->name . "\n";
#	my $new_cd = $schema->resultset('CD')->new({ title => 'Spoon' . $_->name, cdid=>$count });
#	$new_cd->artist($_);
#	$new_cd->year(1);
#	$new_cd->insert; # Auto-increment primary key filled in after INSERT
#	$count++;
#}

#my $rs = $schema->resultset('User');
#my $count = 1;
#for ($rs->all)
#{
#	my $new_post = $schema->resultset('Post')->new({post_id => $count, title=>"Hui" . $_->nickname, views=>0, stars=>0});
#	$new_post->author($_);
#	$count++;
#	$new_post->insert;
#}#

for ($schema->resultset('Post')->all)
{
	print $_->author->nickname . " " . $_->title . " \n";
}
#
#my $ua = LWP::UserAgent->new();
#
#my $res = $ua->get("https://geektimes.ru/users/marks");
#
#if ($res->is_success()) {
#	my $parser = Local::Habr::Parser->new();
#	my $result = $parser->get_user($res->content);
#	print Dumper($result);
#}
#$res = $ua->get("https://geektimes.ru/post/145527/");
#$res = $ua->get("https://habrahabr.ru/post/314540/");
#$res = $ua->get("https://habrahabr.ru/post/314344");

#if ($res->is_success()) {
#    my $parser = Local::Habr::Parser->new();
#    my $result = $parser->get_post($res->content);
#    print Dumper($result);
#}
