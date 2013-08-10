package App::skryf::Model::Page;

use Mojo::Base 'App::skryf::Model::Base';

use App::skryf::Util;
use Text::WikiCreole;
use Method::Signatures;
use DateTime;

method pages {
    $self->mgo->db->collection('pages');
}

method all {
    $self->pages->find->sort({created => -1})->all;
}

method get ($slug) {
    $self->pages->find_one({slug => $slug});
}

method create ($topic, $content, $created = DateTime->now) {
    my $slug = App::skryf::Util->slugify($topic);
    creole_tag("pre", "open", "<pre class='prettyprint'>");
    my $html = creole_parse($content);
    $self->pages->insert(
        {   slug    => $slug,
            topic   => $topic,
            content => $content,
            created => $created->strftime('%Y-%m-%dT%H:%M:%SZ'),
            html    => $html,
        }
    );
}

method save ($page) {
    $page->{slug} = App::skryf::Util->slugify($page->{topic});
    $page->{html} = creole_parse($page->{content});
    my $lt = DateTime->now;
    $page->{modified} = $lt->strftime('%Y-%m-%dT%H:%M:%SZ');
    $self->pages->save($page);
}

method remove ($slug) {
    $self->pages->remove({slug => $slug});
}

1;
