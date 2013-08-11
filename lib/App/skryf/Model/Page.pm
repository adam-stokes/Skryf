package App::skryf::Model::Page;

use Mojo::Base 'App::skryf::Model::Base';

use App::skryf::Util;
use Method::Signatures;
use DateTime;

use constant USE_WIKILINKS => 1;

method pages {
    $self->mgo->db->collection('pages');
}

method all {
    $self->pages->find->sort({created => -1})->all;
}

method get ($slug) {
    $self->pages->find_one({slug => $slug});
}

method create ($slug, $content, $created = DateTime->now) {
    $self->pages->insert(
      {
            slug => $slug,
            content => $content,
            created => $created->strftime('%Y-%m-%dT%H:%M:%SZ'),
        }
    );
}

method save ($page) {
    my $lt = DateTime->now;
    $page->{modified} = $lt->strftime('%Y-%m-%dT%H:%M:%SZ');
    $self->pages->save($page);
}

method remove ($slug) {
    $self->pages->remove({slug => $slug});
}

1;
