package App::skryf::Login;

use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::User;

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
    my $user = $self->param('username');
    my $pass = $self->param('password');

    my $model =
      App::skryf::Model::User->new;
    if ($model->check($user, $pass)) {
        $self->session(user => 1);
        $self->redirect_to('admin_blog_index');
    } else {
      $self->flash(message => 'failed auth.');
      $self->redirect_to('login');
    }
}

1;
