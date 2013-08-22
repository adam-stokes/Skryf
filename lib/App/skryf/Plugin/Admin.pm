package App::skryf::Plugin::Admin;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

use App::skryf::Plugin::Admin::Controller;

my %defaults = (

    # Default routes
    adminPathPrefix => '/admin/',

    # Router namespace
    namespace => 'App::skryf::Plugin::Admin::Controller',
);

sub register {
    my ($self, $app) = @_;
    my (%conf) = (%defaults, %{$_[2] || {}});

    $app->helper(adminconf => sub { \%conf });
    my $auth_r = $app->routes->under(
      sub {
        my $self = shift;
        return $self->session('user') || !$self->redirect_to('login');
      }
    );
    $auth_r->route($conf{adminPathPrefix} . "")->via('GET')->to(
        namespace  => $conf{namespace},
        action     => 'admin_dashboard',
        _admin_conf => \%conf,
    )->name('admin_dashboard');
    return;
}

1;
__END__

=head1 NAME

App::skryf::Plugin::Admin - Mojolicious Plugin

=head1 DESCRIPTION

L<App::skryf::Plugin::Admin> is a L<Mojolicious> plugin.

=head1 METHODS

L<App::skryf::Plugin::Admin> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
