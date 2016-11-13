package Local::Habr;

use strict;
use warnings;
use Local::Habr::Parser;
use Local::Habr::Schema;

use LWP::UserAgent;
use Data::Dumper;


=encoding utf8

=head1 NAME

Local::Habr - habrahabr.ru crawler

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

our %CFG = (
	"site" 		=> "habrahabr.ru",
	"format" 	=> "ddp",
	"refresh" 	=> undef,
	"command"	=> undef,
	"comhash" 	=> {
			"id" 	=> undef,
			"name" 	=> undef,
			"post" 	=> undef,
			"n"	 	=> undef,
	},	
);

sub GetUserByName {
	my ($name) = @_;
	my $schema = Local::Habr::Schema->connect("dbi:SQLite:dbname=test.db", "", "");
	my $user = $schema->resultset('User')->find({nickname=>{ like => $name }});
	if (defined $user) {
		print ("EBAA " . $user->nickname);
	} else{
		my $res = LWP::UserAgent->new()->get("https://" . $CFG{site} . "/users/" . $name);
		if ($res->is_success()) {
			my $parser = Local::Habr::Parser->new();
			$user = $parser->get_user($res->content);
			print Dumper($user);
			$schema->resultset('User')->create($user);
		}
	}	
}

sub GetUserByPost {
	my ($post) = @_;

}

1;
