package App::skryf::Model::Base;

use strict;
use warnings;

use Mojo::Base -base;
use Mango;

sub db {
  my $self = shift;
  my $db = Mango->new($self->config->{db}{dsn});
  $db->default_db('skryf');
}

sub blog {
  my $self = shift;
  $self->db->collection('blog');
}

sub users {
  my $self = shift;
  $self->db->collection('user');
}

1;
