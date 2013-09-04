package App::skryf::Plugin::Admin::Controller;

use Mojo::Base 'Mojolicious::Controller';
use Method::Signatures;
use App::skryf::Model::User;

method admin_dashboard {
    $self->render('admin/dashboard');
}

method admin_dashboard_profile {
    my $req   = $self->req->method;
    my $model = App::skryf::Model::User->new;
    my $user  = $model->get($self->session->{username});
    if ($req eq "POST") {
        $user->{attrs}{email}              = $self->param('email');
        $user->{attrs}{facebook}{username} = $self->param('facebook');
        $user->{attrs}{twitter}{username}  = $self->param('twitter');
        $user->{attrs}{gplus}{username}    = $self->param('gplus');
        $user->{attrs}{github}{username}   = $self->param('github');
        $user->{attrs}{disqus}{username}   = $self->param('disqus');
        $model->save($user);
        $self->flash(message => 'User profile saved.');
        $self->redirect_to('admin_dashboard_profile');
    }
    $self->stash(profile => $user);
    $self->render('admin/dashboard_profile');
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
