package App::skryf::Model::Post;

use Mojo::Base 'App::skryf::Model::Base';

use App::skryf::Util;
use Method::Signatures;
use Time::Piece::ISO;

method posts {
    $self->mgo->db->collection('posts');
}

method all {
   $self->posts->find->sort({created => -1})->all;
}

method get ($slug) {
    $self->posts->find_one({slug => $slug});
}

method create ($topic, $content, $tags, $created = localtime) {
    my $slug = App::skryf::Util->slugify($topic);
    my $html = App::skryf::Util->convert($content);
    $self->posts->insert(
        {   slug    => $slug,
            topic   => $topic,
            content => $content,
            tags    => $tags,
            created => $created,
            html    => $html,
        }
    );
}

method save ($post) {
    $post->{slug} = App::skryf::Util->slugify($post->{topic});
    $post->{html} = App::skryf::Util->convert($post->{content});
    my $lt = localtime;
    $post->{modified} = $lt;
    $self->posts->save($post);
}

method remove ($slug) {
    $self->posts->remove({slug => $slug});
}

method by_cat ($category) {
  my $_filtered = [];
  foreach ( @{$self->all} ) {
    if ( ( my $found = $_->{tags} ) =~ /$category/ ) {
      push @{$_filtered}, $_;
    }
  }
  return $_filtered;
}

1;
