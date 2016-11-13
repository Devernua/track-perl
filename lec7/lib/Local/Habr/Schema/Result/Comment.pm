package Local::Habr::Schema::Result::Comment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('comment');
__PACKAGE__->add_columns(qw/ user_id post_id /);
__PACKAGE__->belongs_to(user => 'Local::Habr::Schema::Result::User', 'user_id');
__PACKAGE__->belongs_to(post => 'Local::Habr::Schema::Result::Post', 'post_id');

1;
