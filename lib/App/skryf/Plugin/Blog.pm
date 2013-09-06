package App::skryf::Plugin::Blog;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';
use Mango::BSON ':bson';

use App::skryf::Plugin::Blog::Controller;

my %defaults = (

    # Default routes
    indexPath       => '/post/',
    postPath        => '/post/:slug',
    feedPath        => '/post/feeds/atom.xml',
    feedCatPath     => '/post/feeds/:category/atom.xml',
    adminPathPrefix => '/admin/post/',
    namespace       => 'App::skryf::Plugin::Blog::Controller',
);

sub register {
    my ($self, $app) = @_;
    my (%conf) = (%defaults, %{$_[2] || {}});

    $app->routes->route($conf{feedPath})->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'blog_feeds',
    )->name('blog_feeds');

    $app->routes->route($conf{feedCatPath})->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'blog_feeds_by_cat',
    )->name('blog_cat_feeds');

    $app->routes->route($conf{indexPath})->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'blog_index',
    )->name('blog_index');

    $app->routes->route($conf{postPath})->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'blog_detail',
    )->name('blog_detail');

    my $auth_r = $app->routes->under(
        sub {
            my $self = shift;
            return $self->session('user') || !$self->redirect_to('login');
        }
    );
    $auth_r->route($conf{adminPathPrefix})->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'admin_blog_index',
    )->name('admin_blog_index');

    $auth_r->route($conf{adminPathPrefix} . "new")->via(qw(GET POST))->to(
        namespace => $conf{namespace},
        action    => 'admin_blog_new',
    )->name('admin_blog_new');
    $auth_r->route($conf{adminPathPrefix} . "edit/:slug")->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'admin_blog_edit',
    )->name('admin_blog_edit');
    $auth_r->route($conf{adminPathPrefix} . "update")->via('POST')->to(
        namespace => $conf{namespace},
        action    => 'admin_blog_update',
    )->name('admin_blog_update');
    $auth_r->route($conf{adminPathPrefix} . "delete/:slug")->via('GET')->to(
        namespace => $conf{namespace},
        action    => 'admin_blog_delete',
    )->name('admin_blog_delete');

    # register menu item
    push @{$app->admin_menu},
      { menu => {
            name   => 'Posts',
            action => 'admin_blog_index',
        }
      };
    push @{$app->frontend_menu},
      { menu => {
            name   => 'Archives',
            action => 'blog_index'
        }
      };
    return;
}

1;
__END__

=head1 NAME

App::skryf::Plugin::Blog - Skryf Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Blog');

  # Mojolicious::Lite
  plugin 'Blog';

  # skryf.conf
  extra_modules => {Blog => 1}

=head1 DESCRIPTION

L<App::skryf::Plugin::Blog> is a L<App::skryf> plugin.

=head1 OPTIONS

=head2 indexPath

Blog index route

=head2 postPath

Blog detail post path

=head2 adminPathPrefix

Blog admin prefix route

=head2 feedPath

Path to RSS feed

=head2 feedCatPath

Path to categorized RSS feed

=head2 namespace

Blog controller namespace.

=head1 METHODS

L<App::skryf::Plugin::Blog> inherits all methods from
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

L<App::skryf>, L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
