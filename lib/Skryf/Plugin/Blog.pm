package Skryf::Plugin::Blog;

use Mojo::Base 'Mojolicious::Plugin';

use Skryf::Model::Blog;
use Skryf::Util;

our $VERSION = '0.99_5';

sub register {
    my ($self, $app) = @_;
    $app->helper(
        model => sub {
            my $self = shift;
            return Skryf::Model::Blog->new(
                dbname => $self->config->{dbname});
        }
    );

    $app->helper(
        blog_all => sub {
            my $self = shift;
            return Skryf::Util->json->encode($self->model->all);
        }
    );

    $app->helper(
        blog_one => sub {
            my $self = shift;
            my $slug = shift;
            return Skryf::Util->json->encode($self->model->get($slug))
              || undef;
        }
    );

    $app->helper(
        blog_feed => sub {
            my $self  = shift;
            my $posts = $self->model->all;
            my $feed  = Skryf::Util->feed($self->config, $posts);
            return $feed->as_string;
        }
    );

    $app->helper(
        blog_feed_by_cat => sub {
            my $self     = shift;
            my $category = shift;
            my $posts    = $self->model->by_cat($category);
            my $feed     = Skryf::Util->feed($self->config, $posts);
            return $feed->as_string;
        }
    );

###############################################################################
# Routes
###############################################################################
    $app->routes->route('/blog')->via('GET')->to(
        cb => sub {
            my $self = shift;
            $self->render(json => {postlist => $self->blog_all});
        }
    )->name('blog_index');
    $app->routes->route('/blog/:slug')->via('GET')->to(
        cb => sub {
            my $self = shift;
            my $slug = $self->param('slug');
            $self->render(json => {post => $self->blog_one($slug)});
        }
    )->name('blog_detail');
    $app->routes->route('/blog/feed')->via('GET')->to(
        cb => sub {
            my $self = shift;
            $self->render(xml => $self->blog_feed);
        }
    )->name('blog_feed');
    $app->routes->route('/blog/feed/:category')->via('GET')->to(
        cb => sub {
            my $self     = shift;
            my $category = $self->param('category');
            $self->render(xml => $self->blog_feed_by_cat($category));
        }
    )->name('blog_feed_category');

    # Admin hooks
    my $auth_r = $app->routes->under($app->is_admin);
    if ($auth_r) {
        $auth_r->route('/admin/blog')->via('GET')->to(
            cb => sub {
                my $self = shift;
                $self->render('/admin/blog/dashboard');
            }
        )->name('admin_blog_dashboard');
        $auth_r->route('/admin/blog/edit/:slug')->via('GET')->to(
            cb => sub {
                my $self = shift;
                my $slug = $self->param('slug');
                $self->stash(post => $self->model->get($slug));
                $self->render('/admin/blog/edit');
            }
        )->name('admin_blog_edit');
        $auth_r->route('/admin/blog/new')->via(qw[GET POST])->to(
            cb => sub {
                my $self = shift;
                if ($self->req->method eq "POST") {
                    $self->flash(message => "Saved.");
                    $self->redirect_to('admin_blog_dashboard');
                }
                else {
                    $self->render('/admin/blog/new');
                }
            }
        )->name('admin_blog_new');
        $auth_r->route('/admin/blog/update/:slug')->via('POST')->to(
            cb => sub {
                my $self       = shift;
                my $slug       = $self->param('slug');
                my $saved_post = $self->model->get($slug);
                if ($saved_post) {

                    # DO update
                }
                else {
                    $self->flash(
                        message => sprintf("Could not find post: %s", $slug));
                    $self->redirect_to('admin_blog_dashboard');
                }
                $self->redirect_to(
                    $self->url_for('admin_blog_edit', {slug => $slug}));
            }
        )->name('admin_blog_update');
        $auth_r->route('/admin/blog/delete/:slug')->via('POST')->to(
            cb => sub {
                my $self = shift;
                my $slug = $self->param('slug');
                $self->model->remove($slug);
                $self->flash(message => sprintf("Post: %s deleted.", $slug));
                $self->redirect_to($self->url_for('admin_blog_dashboard'));
            }
        )->name('admin_blog_delete');
    }
    return;
}

1;
__END__

=head1 NAME

Skryf::Plugin::Blog - Skryf Plugin

=head1 SYNOPSIS

  # In Skryf configuration
  plugins => {Blog => 1}

=head1 DESCRIPTION

L<Skryf::Plugin::Blog> is a L<Skryf> plugin.

=head1 HELPERS

=head2 model

=head2 blog_all

=head2 blog_one

=head2 blog_feed

=head2 blog_feed_by_cat

=head1 METHODS

L<Skryf::Plugin::Blog> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

    $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 ROUTES

A list of current available routes:

    /blog                           GET       "blog_index"
    /blog/:slug                     GET       "blog_detail"
    /blog/feed/                     GET       "blog_feed"
    /blog/feed/:category/           GET       "blog_feed_category"

=head1 RETURN VALUE

Except for the RSS feeds these routes return JSON output of either a
single post or multiple posts. The top level keys associated with each
are described below.

=head2 post

  $c = Mojo::JSON->decode($ua->get('/blog/a-post-slug')->res->body);
  <%= $c->{post}->{title} %>

A single blog post object

=head2 postlist

  $c = Mojo::JSON->decode($ua->get('/blog')->res->body);
  <% for my $post ( @{$c->{postlist}} ) { %>
    <%= $post->{title} %>
  <% } %>

Multiple blog post objects.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 LICENSE

Licensed under the same terms as Perl.

=head1 SEE ALSO

L<Skryf>, L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
