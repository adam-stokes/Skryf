package Skryf::Admin;

# ABSTRACT: admin controller

use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);

sub dashboard {
    my $self = shift;
    $self->render('/admin/dashboard');
}

sub users {
  my $self = shift;
  my $users = $self->db->namespace('users')->find()->all;
  $self->stash(userlist => $users);
  $self->render('/admin/users/index');
}

sub modify_user {
    my $self     = shift;
    my $username = $self->param('username');
    my $user =
      $self->db->namespace('users')->find_one({username => $username});
    $self->stash(user => $user);
    if ($self->req->method eq "POST") {
        my $params = $self->req->params->to_hash;
        if ($params->{password}) {
            $params->{password} =
              hmac_sha1_sum($self->secrets->[0], $params->{password});
        }
        if ($user) {
            $self->db->namespace('users')
              ->update({username => $user}, $params);
        }
        else {
            $self->db->namespace('users')->insert($params);
        }
        $self->stash(message => "User updated.");
        $self->redirect_to($self->url_for('admin_users'));
    }
    else {
        $self->stash(user => $user);
        $self->render('/admin/users/modify');
    }

}

sub delete_user {
    my $self = shift;
    my $user = $self->param('username');
    $self->db->namespace('users')->remove({username => $user});
    $self->flash(message => sprintf("User: %s deleted", $user));
    $self->redirect_to($self->url_for('admin_users'));
}

1;
