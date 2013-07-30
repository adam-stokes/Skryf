use strict;
use warnings;

package App::skryf::Model::Post;

use Mojo::Base -base;
use App::skryf::Util;
use Method::Signatures;
use Data::Printer;

has db => sub {};

method all {
    $self->db->find->batch_size(2)->all;
}

method get ($slug) {
    $self->db->find_one({slug => $slug});
}

method new_post ($topic, $content, $tags) {
    my $slug = App::skryf::Util->slugify($topic);
    my $html = App::skryf::Util->convert($content);
    $self->db->insert(
        {   slug    => $slug,
            topic   => $topic,
            content => $content,
            tags    => $tags,
            html    => $html,
        }
    );
}

method update_post ($topic, $content, $tags) {
    my $slug = App::skryf::Util->slugify($topic);
    my $html = App::skryf::Util->convert($content);
    $self->db->update(
        {slug => $slug},
        {   topic   => $topic,
            content => $content,
            tags    => $tags,
            html    => $html,
        }
    );
}

method delete_post ($slug) {
    $self->db->remove({slug => $slug});
}

1;
