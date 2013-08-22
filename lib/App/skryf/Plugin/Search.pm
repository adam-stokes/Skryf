package App::skryf::Plugin::Search;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

use App::skryf::Plugin::Search::Controller;

my %defaults = (
    indexPath   => '/search/',
    namespace   => 'App::skryf::Plugin::Search::Controller',
);

sub register {
    my ($self, $app) = @_;
    my (%conf) = (%defaults, %{$_[2] || {}});

    $app->helper(search => sub { \%conf });
    $app->routes->route($conf{indexPath})->via(qw(GET POST))->to(
        namespace    => $conf{namespace},
        action       => 'search_index',
        _search_conf => \%conf,
    )->name('search_index');
    return;
}

1;
__END__

=head1 NAME

App::skryf::Plugin::Search - Mojolicious Plugin

=head1 DESCRIPTION

L<App::skryf::Plugin::Search> is a L<Mojolicious> plugin.

=head1 METHODS

L<App::skryf::Plugin::Search> inherits all methods from
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
