package App::skryf::Model::Post;

use Mojo::Base 'App::skryf::Model::Base';

use App::skryf::Util;
use Method::Signatures;
use DateTime;

method posts {
    $self->mgo->db->collection('posts');
}

method all {
    $self->posts->find->batch_size(2)->all;
}

method get ($slug) {
    $self->posts->find_one({slug => $slug});
}

method create ($topic, $content, $tags) {
    my $slug = App::skryf::Util->slugify($topic);
    my $html = App::skryf::Util->convert($content);
    my $lt = DateTime->now;
    $self->posts->insert(
        {   slug    => $slug,
            topic   => $topic,
            content => $content,
            tags    => split(/,/, $tags),
            html    => $html,
            created => $lt->datetime(),
        }
    );
}

method save ($post) {
    $post->{slug} = App::skryf::Util->slugify($post->{topic});
    $post->{html} = App::skryf::Util->convert($post->{content});
    my $lt = DateTime->now;
    $post->{modified} = $lt->datetime();
    $self->posts->save($post);
}

method remove ($slug) {
    $self->posts->remove({slug => $slug});
}

method by_cat ($category) {
  my $_filtered = [];
  foreach ( @{$self->all} ) {
    if ( grep { !/$category/ } $_->{tags} ) {;
      push @{$_filtered}, $_;
    }
  }
  return $_filtered;
}

1;
