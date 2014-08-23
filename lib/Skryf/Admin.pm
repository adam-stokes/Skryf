package Skryf::Admin;

# ABSTRACT: admin controller

use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use Hash::Merge;
use DateTime;

sub dashboard {
    my $self = shift;
    $self->render('/admin/dashboard');
}

sub site_settings {
    my $self = shift;
    $self->render('/admin/site_settings');
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
        $params->{created} = DateTime->now;
        if ($user) {
            if ($params->{password} eq $params->{confirmpassword}) {
                $params->{password} =
                  hmac_sha1_sum($self->app->secrets->[0],
                    $params->{password});
            }
            my $merge = Hash::Merge->new('RIGHT_PRECEDENT');
            $self->db->namespace('users')->save($merge->merge($user, $params));
        }
        else {
            $params->{password} =
              hmac_sha1_sum($self->app->secrets->[0], $params->{password});
            $self->db->namespace('users')->insert($params);
        }
        $self->flash(success => "User updated.");
        $self->redirect_to($self->url_for('admin_users'));
    }
    else {
        $self->render('/admin/users/modify');
    }
}

sub delete_user {
    my $self = shift;
    my $username = $self->param('username');
    my $user =
      $self->db->namespace('users')->find_one({username => $username});
    if ($user->{roles}->{admin}->{is_owner} == 1) {
      $self->flash(warning => "You cannot delete the owner.");
    } else {
      $self->db->namespace('users')->remove({username => $username});
      $self->flash(success => sprintf("User: %s deleted", $username));
    }
    $self->redirect_to($self->url_for('admin_users'));
}

1;
