package Skryf::Welcome;

use Mojo::Base 'Mojolicious::Controller';

our $VERSION = '1.0.0';

sub index {
  my $self = shift;
  $self->render('welcome');
}

1;
