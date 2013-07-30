use strict;
use warnings;

package App::skryf::Model::Post;

use Mojo::Base -base;
use App::skryf::Util;
use Data::Printer;

has db => sub {};

sub all {
    my ($self) = @_;
    $self->db->find->batch_size(2)->all;
}

sub new_post {
    my ($self, $topic, $content, $tags) = @_;
    my $slug = App::skryf::Util->slugify($topic);
    my $html = App::skryf::Util->convert($content);
    if (!$self->db->find_one({slug => $slug})) {
        $self->db->insert(
            {   slug    => $slug,
                topic   => $topic,
                content => $content,
                tags    => $tags,
                html    => $html,
            }
        );
    }
    else {
        $self->db->update(
            {slug => $slug},
            {   topic   => $topic,
                content => $content,
                tags    => $tags,
                html    => $html, 
            }
        );
    }
}

sub delete_post {
    my ($self, $slug) = @_;
    $self->db->remove({slug => $slug});
}
1;
