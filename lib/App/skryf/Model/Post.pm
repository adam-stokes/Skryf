use strict;
use warnings;

package App::skryf::Model::Post;

use Mojo::Base -base;
use App::skryf::Util;

has db => sub {};

sub all {
    my ($self) = @_;
    $self->db->find->batch_size(2)->all;
}

1;
