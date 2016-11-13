package Local::Habr::Schema::Result::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
	user_id => {
		data_type => 'integer',
	},
	nickname => {
		data_type => 'varchar',
		size => 100,
	},
	karma => {
		data_type => 'float',
	},
	rating => {
		data_type => 'float',
	},
);

__PACKAGE__->set_primary_key('user_id');
__PACKAGE__->has_many(posts => 'Local::Habr::Schema::Result::Post', 'user_id');

__PACKAGE__->has_many(comments => 'Local::Habr::Schema::Result::Comment', 'user_id');
__PACKAGE__->many_to_many(commented_posts => 'comments', 'post');

1;
