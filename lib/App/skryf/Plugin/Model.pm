package App::skryf::Plugin::Model;

use strict;
use warnings;

use base 'Mojolicious::Plugin';

use App::skryf::Model::Post;

sub register {
  my ($self, $app) = @_;

  $app->helper(
    get_article => sub {
      my $self = shift;
      App::skryf::Model::Post->new(db => $app->db, @_);
    }
  );
}
1;
