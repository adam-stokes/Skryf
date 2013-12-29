package App::skryf::Welcome;

use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;
  $self->render('welcome');
}

1;
