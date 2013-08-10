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
