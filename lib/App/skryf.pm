use strict;
use warnings;

package App::skryf;

use Mojo::Base 'Mojolicious';
use App::skryf::Model::User;

use Carp;
use File::ShareDir ':ALL';
use Mango;
use Path::Tiny;
use Data::Printer;

our $VERSION = '0.009';

sub startup {
    my $self = shift;
    $self->secret("WHO CARES RITE?");
###############################################################################
# Setup configuration
###############################################################################
    my $cfgfile = undef;
    if ($self->mode eq "development") {
        $cfgfile = path(dist_dir('App-skryf'), 'skryf.conf');
    }
    else {
        $cfgfile = path("~/.skryf.conf");
        path(dist_dir('App-skryf'), "skryf.conf")->copy($cfgfile)
          unless $cfgfile->exists;
    }

    $self->plugin('Config' => {file => $cfgfile});

    my $cfg = $self->config->{skryf} || +{};

###############################################################################
# Load plugins
###############################################################################
    for (keys $cfg->{extra_modules}) {
        $self->plugin("$_") if $cfg->{extra_modules}{$_} > 0;
    }

###############################################################################
# Define template, media, static paths
###############################################################################
    my $template_directory = undef;
    my $media_directory    = undef;
    if ($self->mode eq "development") {
        $template_directory = path(dist_dir('App-skryf'), 'templates');
        $media_directory    = path(dist_dir('App-skryf'), 'public');
    }
    else {
        $template_directory = path($cfg->{template_directory});
        $media_directory    = path($cfg->{media_directory});
    }

    croak("A template|media|static directory must be defined.")
      unless $template_directory->is_dir
      && $media_directory->is_dir;

    push @{$self->renderer->paths}, $template_directory;
    push @{$self->static->paths},   $media_directory;

# use App::skryf::Command namespace
    push @{$self->commands->namespaces}, 'App::skryf::Command';

###############################################################################
# Mongo setup
###############################################################################
    $self->attr(mango => sub { Mango->new($cfg->{db}{dsn}) });
    $self->app->mango->default_db('skryf');
    $self->helper('db' => sub { shift->app->mango->db->collection('blog') });
###############################################################################
# Configuration helper
###############################################################################
    $self->helper(cfg => sub {$cfg});

###############################################################################
# User Model helper
###############################################################################
    $self->helper(
        users => sub {
            shift->app->mango->db->collection('user');
        }
    );

###############################################################################
# Routing
###############################################################################
    my $r = $self->routes;
    # RSS
    $r->get('/atom.xml')->to('blog#feeds')->name('feeds');
    $r->get('/feeds/:category/atom.xml')->to('blog#feeds_by_cat')
      ->name('feeds_by_cat');
    # Authentication
    $r->get('/login')->to('login#login')->name('login');
    $r->get('/logout')->to('login#logout')->name('logout');
    $r->post('/auth')->to('login#auth')->name('auth');
    # Post view
    $r->get('/post/:slug')->to('blog#post_page')->name('post_page');
    my $logged_in = $r->under(
        sub {
            my $self = shift;
            return $self->session('user') || !$self->redirect_to('login');
        }
    );
    $logged_in->get('/admin')->to('admin#index')->name('admin_index');
    # Admin post additions/modifications
    $logged_in->route('/admin/post/new')->via(qw[GET POST])->to('admin#new_post')
      ->name('admin_new_post');
    $logged_in->route('/admin/post/edit/:slug')->via(qw[GET POST])->to('admin#edit_post')
      ->name('admin_edit_post');
    $logged_in->get('/admin/post/delete/:slug')->to('admin#delete_post')
      ->name('admin_delete_post');
    # Static page view
    $r->get('/:slug')->to('blog#static_page')->name('static_page');
    # Root
    $r->get('/')->to('blog#index')->name('index');
}

1;

__END__

=head1 NAME

App-skryf - i kno rite. another perl blogging engine.

=head1 DESCRIPTION

Another blog engine which utilizes

=over 8

=item Mojolicious

=item Markdown

=item Hypnotoad

=item Rex

=item Ubic 

=item Mongo

=back

For a more streamlined deployable approach.

=head1 PREREQS

I like L<http://perlbrew.pl>, but, whatever you're comfortable with. I won't judge.

=head1 INSTALLATION (BLEEDING EDGE)

    $ cpanm git://github.com/battlemidget/App-skryf.git

=head1 SETUP

By default B<skryf> will look in dist_dir for templates and media. To override that
make sure I<~/.skryf.conf> points to the locations of your templates and media.
For example, this is a simple directory structure for managing your blog media and templates.

    $ mkdir -p ~/blog/{templates,public}

Edit ~/.skryf.conf to reflect those directories in I<media_directory> and 
I<public_directory>.

    template_directory => '~/blog/templates',
    media_directory    => '~/blog/public',

So B<~/blog/templates/{post.html.ep,index.html.ep,about.html.ep}> and B<~/blog/public/style.css>

=head1 NEW POST

    $ skryf newpost a-new-blog-post

=head1 NEW PAGE

    $ skryf newpage an-about-page

=head1 DEPLOY

    $ export BLOGUSER=username
    $ export BLOGSERVER=example.com

    If perlbrew is installed Rex will autoload that environment to use remotely.
    Otherwise more tinkering is required to handle the perl environment remotely.
    $ rexify --use=Rex::Lang::Perl::Perlbrew
    $ rex deploy

=head1 RUN (Development)

    $ skryf daemon

=head1 RUN (Production)

I use Ubic to manage the process

     use Ubic::Service::SimpleDaemon;
     my $service = Ubic::Service::SimpleDaemon->new(
      bin => "hypnotoad -f `which skryf`",
      cwd => "/home/username",
      stdout => "/tmp/blog.log",
      stderr => "/tmp/blog.err.log",
      ubic_log => "/tmp/blog.ubic.log",
      user => "username"
     );

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 DISCLAIMER

Jon Portnoy [avenj at cobaltirc.org](http://www.cobaltirc.org) is original 
author of blagger in which this code is morphed heavily off of.

=head1 LICENSE

Licensed under the same terms as Perl.

=cut
