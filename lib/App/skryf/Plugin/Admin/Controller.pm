package App::skryf::Plugin::Admin::Controller;

use Mojo::Base 'Mojolicious::Controller';
use Method::Signatures;

method admin_dashboard {
  $self->render('admin/dashboard');
}

1;
