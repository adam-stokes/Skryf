package Skryf::Auth;

# ABSTRACT: Skryf login controller

use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);

sub login {
    my $self = shift;
    $self->flash(message => 'You are logged in.');
    $self->render('login');
}

sub logout {
    my $self = shift;
    $self->session(expires => 1);
    $self->flash(message => 'You are now logged out.');
    $self->redirect_to($self->config->{landing_page});
}

sub verify {
    my $self = shift;
    my $user = $self->db->namespace('users')
      ->find_one({username => $self->param('username')});
    my $entered_pass =
      hmac_sha1_sum($self->app->secrets->[0], $self->param('password'));
    if ($entered_pass eq $user->{password}) {
        $self->flash(success => 'Youre authenticated!');
        $self->session(username => $user->{username});
        $self->session(domain   => $user->{domain});
        $self->redirect_to('welcome');
    }
    else {
        $self->flash(
            danger => 'Incorrect password/username, please try again.');
        $self->redirect_to('login');
    }
}

1;
