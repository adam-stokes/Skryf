package App::skryf::Plugin::Admin::Controller;

use Mojo::Base 'Mojolicious::Controller';
use Method::Signatures;
use Data::Printer;

method admin_dashboard {
  p($self->app->admin_menu);
  $self->render('admin/dashboard');
}

1;
__END__

=head1 NAME

App::skryf::Plugin::Admin::Controller - Admin plugin controller

=head1 DESCRIPTION

Admin plugin for handling dashboard views and other core system
specific tasks.

=head1 CONTROLLERS

=head2 B<admin_dashboard>

Index controller for admin dashboard

=cut
