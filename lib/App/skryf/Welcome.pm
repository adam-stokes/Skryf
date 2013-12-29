package App::skryf::Welcome;

use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;
  $self->render(text => 'Welcome to your Skryf application.');
}

1;
