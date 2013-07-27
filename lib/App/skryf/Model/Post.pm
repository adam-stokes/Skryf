use strict;
use warnings;

package App::skryf::Model::Post;

use Mojo::Base -base;
use App::skryf::Util;

has [qw(db slug mtime topic date category contents published)] => sub {};
has ret   => 0;
has html => sub {
    my ($self) = @_;
    App::skryf::Util->parse_content($self->contents);
};

sub all {
    my ($self) = @_;
    $self->db->find->batch_size(2)->all;
}

1;
