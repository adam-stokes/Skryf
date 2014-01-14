package Skryf::Welcome;

use Mojo::Base 'Mojolicious::Controller';

our $VERSION = '0.99_7';

sub index {
  my $self = shift;
  $self->render('welcome');
}

1;
