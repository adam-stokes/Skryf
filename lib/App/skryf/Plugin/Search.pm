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

App::skryf::Plugin::Search - Skryf Plugin

=head1 DESCRIPTION

L<App::skryf::Plugin::Search> is a L<App::skryf> plugin.

=head1 METHODS

L<App::skryf::Plugin::Search> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 LICENSE

Licensed under the same terms as Perl.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
