package App::skryf::Plugin::Wiki;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

use App::skryf::Plugin::Wiki::Controller;

my %defaults = (
  indexPath => '/pages/',
  pagesPath => '/pages/:slug',
  adminPathPrefix => '/admin/pages/',
  namespace => 'App::skryf::Plugin::Wiki::Controller',
  authCondition => undef,
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
  return; 
}

1;
__END__

=encoding utf-8

=head1 NAME

App::skryf::Plugin::Wiki - Wiki namespace for Skryf

=head1 SYNOPSIS

  use App::skryf::Plugin::Wiki;

=head1 DESCRIPTION

App::skryf::Plugin::Wiki is a wiki plugin for App::skryf that allows for
composition of wiki pages and understands the usage of widgets to extend
the dynamic capabilities of the wiki.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.org<gt>

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
