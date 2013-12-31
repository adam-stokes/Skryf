package App::skryf::Login;

# VERSION

use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use App::skryf::Model::User;
use DDP;

has model => sub { my $self = shift; App::skryf::Model::User->new; };

sub login {
    my $self = shift;
    $self->render('login');
}

sub logout {
    my $self = shift;
    $self->session(expires => 1);
    $self->redirect_to('welcome');
}

sub auth {
    my $self         = shift;
    my $user         = $self->model->get($self->param('username'));
    my $entered_pass = hmac_sha1_sum($self->app->secrets->[0], $self->param('password'));

    if ($entered_pass eq $user->{password}) {
        $self->flash(message => 'authenticated.');
        $self->session(user     => 1);
        $self->session(username => $user);
        $self->redirect_to('welcome');
    }
    else {
        $self->flash(message => 'failed auth.');
        $self->redirect_to('login');
    }
}

1;
