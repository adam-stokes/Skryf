package App::skryf::Plugin::Wiki;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

use App::skryf::Plugin::Wiki::Controller;

my %defaults = (
  indexPath => '/pages/',
  pagesPath => '/pages/:slug',
  adminPathPrefix => '/admin/pages/',
  namespace => 'App::skryf::Plugin::Wiki::Controller',
);

sub register {
  my ($self, $app) = @_;
  my (%conf) = (%defaults, %{$_[2] || {}});

  $app->helper(wiki => sub { \%conf });

  $app->routes->route($conf{indexPath})->via('GET')->to(
    namespace => $conf{namespace},
    action => 'wiki_index',
    _wiki_conf => \%conf,
  )->name('wiki_index');
  $app->routes->route($conf{pagesPath})->via('GET')->to(
    namespace => $conf{namespace},
    action => 'wiki_detail',
    _wiki_conf => \%conf,
  )->name('wiki_detail');

  my $auth_r = $app->routes->under(
    sub {
      my $self = shift;
      return $self->session('user') || !$self->redirect_to('login');
    }
  );
  $auth_r->route($conf{adminPathPrefix})->via(qw(GET))->to(
      namespace  => $conf{namespace},
      action     => 'admin_wiki_index',
      _wiki_conf => \%conf,
  )->name('admin_wiki_index');
    $auth_r->route($conf{adminPathPrefix} . "new/:slug")->via(qw(GET POST))->to(
        namespace  => $conf{namespace},
        action     => 'admin_wiki_new',
        _wiki_conf => \%conf,
    )->name('admin_wiki_new');
    $auth_r->route($conf{adminPathPrefix} . "edit/:slug")->via('GET')->to(
        namespace  => $conf{namespace},
        action     => 'admin_wiki_edit',
        _wiki_conf => \%conf,
    )->name('admin_wiki_edit');
    $auth_r->route($conf{adminPathPrefix} . "update/:slug")->via('POST')->to(
        namespace  => $conf{namespace},
        action     => 'admin_wiki_update',
        _wiki_conf => \%conf,
    )->name('admin_wiki_update');
    $auth_r->route($conf{adminPathPrefix} . "delete/:slug")->via('GET')->to(
        namespace  => $conf{namespace},
        action     => 'admin_wiki_delete',
        _wiki_conf => \%conf,
    )->name('admin_wiki_delete');

    # register menu item
    $app->admin_menu->{Pages} = 'admin_wiki_index';
    $app->frontend_menu->{Wiki} = 'wiki_index';
  return; 
}

1;
__END__

=head1 NAME

App::skryf::Plugin::Wiki - Mojolicious Plugin

=head1 DESCRIPTION

L<App::skryf::Plugin::Wiki> is a L<Mojolicious> plugin.

=head1 METHODS

L<App::skryf::Plugin::Wiki> inherits all methods from
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
