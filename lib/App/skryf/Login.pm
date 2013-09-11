package App::skryf::Login;

use Mojo::Base 'Mojolicious::Controller';

sub login {
  my $self = shift;
  $self->render('login');
}

sub logout {
  my $self = shift;
  $self->session(expires => 1);
  $self->redirect_to('blog_index');
}

sub auth {
    my $self = shift;
    my $model = $self->db('User');
    my $user = $model->get($self->param('username'));
    my $entered_pass = $self->param('password');

    if ($self->bcrypt_validate($entered_pass, $user->{password})) {
        $self->flash(message => 'authenticated.');
        $self->session(user => 1);
        $self->session(username => $user);
        $self->redirect_to('admin_blog_index');
    } else {
      $self->flash(message => 'failed auth.');
      $self->redirect_to('login');
    }
}

1;
