#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Habr;
use DBI;

my $schema = Local::Habr::Schema->connect("dbi:SQLite:dbname=test.db", "", "");
$schema->deploy; #for new db
