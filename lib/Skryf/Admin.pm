package Skryf::Admin;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use Skryf::Model::User;

our $VERSION = '0.99_7';

has model => sub {
    my $self = shift;
    Skryf::Model::User->new(dbname => $self->config->{dbname});
};

sub dashboard {
    my $self = shift;
    $self->render('/admin/dashboard');
}

1;
