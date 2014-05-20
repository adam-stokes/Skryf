package Skryf::Admin;

# ABSTRACT: admin controller

use Mojo::Base 'Mojolicious::Controller';

sub dashboard {
    my $self = shift;
    $self->render('/admin/dashboard');
}

sub users {
  my $self = shift;
  my $users = $self->db->namespace('users')->find()->all;
  $self->stash(userlist => $users);
  $self->render('/admin/users');
}

sub modify {
    my $self     = shift;
    my $username = $self->param('username');
    my $user =
      $self->db->namespace('users')->find_one({username => $username});
    if ($self->req->method eq "POST") {
        my $params = $self->req->params->to_hash;
        if ($user) {
            $self->db->namespace('users')
              ->update({username => $user}, $params);
        }
        else {
            $self->db->namespace('users')->insert($params);
        }
    }
    else {
        $self->stash(user => $user);
        $self->render('/admin/users/modify');
    }

}

1;
