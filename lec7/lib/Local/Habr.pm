package Local::Habr;

use strict;
#use warnings;
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

my $schema = Local::Habr::Schema->connect("dbi:SQLite:dbname=test.db", "", "");
my $agent = LWP::UserAgent->new();
my $parser = Local::Habr::Parser->new();

sub GetUserByName {
	my ($name) = @_;
	my $user = $schema->resultset('User')->find({nickname=>{ like => $name }});
	if (defined $user) {
		my $result = {
			nickname => $user->nickname,
			karma => $user->karma,
			rating => $user->rating
		};
		print "From Database:\n";
		print Dumper($result);
	} else{
		my $res = $agent->get("https://" . $CFG{site} . "/users/" . $name);
		if ($res->is_success()) {
			$user = $parser->get_user($res->content);
			print Dumper($user);
			$schema->resultset('User')->create($user);
		}
	}	
}

sub GetUserByPost {
	my ($post_id) = @_;
	my $post = $schema->resultset('Post')->find($post_id);
	if (defined $post) {
		my $result = {
			nickname => $post->author->nickname,
			karma => $post->author->karma,
			rating => $post->author->rating,
		};
		print "From Database:\n";
		print Dumper($result);
		#print "COMMENTPRS:";
		#print Dumper($post->commentors);
	} else {
		my $res = $agent->get("https://" . $CFG{site} . "/post/" . $post_id);	
		$post = $parser->get_post($res->content);
		$post->{post_id} = $post_id;
		#print Dumper($post);
		$res = $agent->get("https://" . $CFG{site} . "/users/" . $post->{author});
		my $author = $parser->get_user($res->content);
		print Dumper($author);
		#$author = $schema->resultset('User')->update_or_new($author);
		my @commentors = @{$post->{commentors}};
		for (@commentors) {
			$res = $agent->get("https://" . $CFG{site} . "/users/" . $_);
			$_ = $parser->get_user($res->content);
			#$_ = $schema->resultset('User')->update_or_create($_);
		}
		$post->{author} = $author;
		delete $post->{commentors};
		#$post->{comments} = \@commentors;
		#print Dumper(\@commentors);
		$post = $schema->resultset('Post')->create($post);
		for (@commentors) {
			$post->add_to_commentors($_);
		}
	}
}

sub GetPost {
	my ($post_ids) = @_;
	my @result;
	
	for (@$post_ids) {
		my $post = $schema->resultset('Post')->find($_);
		if (defined $post) {
			push(@result, {});
			$result[-1]->{author} = $post->author->nickname;
			$result[-1]->{views} = $post->views;
			$result[-1]->{stars} = $post->stars;
			$result[-1]->{title} = $post->title;
			$result[-1]->{fromDB} = "DA";
			$result[-1]->{commentors} = [];
			for ($post->commentors) {
				push (@{$result[-1]->{commentors}}, $_->nickname);
			}
			
		} else {
			my $res = $agent->get("https://". $CFG{site} . "/post/". $_);
			$post = $parser->get_post($res->content);
			push(@result, {%{$post}});
			$post->{post_id} = $_;
			$res = $agent->get("https://" . $CFG{site} . "/users/" . $post->{author});
			my $author = $parser->get_user($res->content);
			$post->{author} = $author;
			my @commentors = @{$post->{commentors}};
			for (@commentors) {
				$res = $agent->get("https://" . $CFG{site} . "/users/" . $_);
				$_ = $parser->get_user($res->content);		
			}
			delete $post->{commentors};
			$post = $schema->resultset('Post')->create($post);
			for (@commentors) {
				$post->add_to_commentors($_);
			}
		}
	}	
	print Dumper(\@result);
}

sub GetCommenters {
	my ($post_id) = @_;
	my $result = [];	
	my $post = $schema->resultset('Post')->find($post_id);
	if (defined $post) {
		print "FROM DB:\n";
		for ($post->commentors) {
			push(@$result, {
				nickname => $_->nickname,
				karma => $_->karma,
				rating => $_->rating,
			});
		}
	} else {
		my $res = $agent->get("https://". $CFG{site} . "/post/". $post_id);
		$post = $parser->get_post($res->content);
		$post->{post_id} = $post_id;
		my @commentors = @{$post->{commentors}};
		for (@commentors) {
			$res = $agent->get("https://" . $CFG{site} . "/users/" . $_);
			$_ = $parser->get_user($res->content);
		}
		$result = \@commentors;
		$res = $agent->get("https://" . $CFG{site} . "/users/" . $post->{author});
		my $author = $parser->get_user($res->content);
		$post->{author} = $author;
		delete $post->{commentors};
		$post = $schema->resultset('Post')->create($post);
		for (@commentors) {
			$post->add_to_commentors($_);
		}
	}
	print Dumper($result);		
}
	
sub GetSelfCommenters {
	my @result;
	for ($schema->resultset('User')->all()) {
		if ($_->commented_posts->search_related('author', {'author.nickname' => $_->nickname})->count()) {
			push (@result, {
					nickname => $_->nickname,
					karma => $_->karma,
					rating => $_->rating,
			});
		}
	}
	print Dumper(\@result);
}

sub GetDesertPosts {
	my ($n) = @_;
	my @result;
	for ($schema->resultset('Post')->all()){
		if ($_->commentors->count() < $n) {
			push(@result, {});
			$result[-1]->{author} = $_->author->nickname;
			$result[-1]->{views} = $_->views;
			$result[-1]->{stars} = $_->stars;
			$result[-1]->{title} = $_->title;
			$result[-1]->{fromDB} = "DA";
			$result[-1]->{commentors} = [];
			for ($_->commentors) {
				push (@{$result[-1]->{commentors}}, $_->nickname);
			}
		}
	}
	print Dumper(\@result);
}  

1;
