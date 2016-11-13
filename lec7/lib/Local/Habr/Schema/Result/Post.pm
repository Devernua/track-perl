package Local::Habr::Schema::Result::Post;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('post');
__PACKAGE__->add_columns(
	post_id => {
		data_type => 'integer',
	},
	title => {
		data_type => 'varchar',
		size => 200,
	},
	views => {
		data_type => 'varchar',
		size => 20,
	},
	stars => {
		data_type => 'integer',
	},
	user_id => {},
);
__PACKAGE__->set_primary_key('post_id');

__PACKAGE__->belongs_to(author => 'Local::Habr::Schema::Result::User', 'user_id');

__PACKAGE__->has_many(comments => 'Local::Habr::Schema::Result::Comment', 'post_id');
__PACKAGE__->many_to_many(commentors => 'comments', 'user');

1;