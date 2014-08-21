package Skryf::Welcome;

# ABSTRACT: Skryf welcome controller

use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    $self->render('welcome');
}

1;
