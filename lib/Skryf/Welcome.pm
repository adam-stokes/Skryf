package Skryf::Welcome;

use Mojo::Base 'Mojolicious::Controller';

our $VERSION = '0.99_5';

sub index {
  my $self = shift;
  $self->render('welcome');
}

1;
