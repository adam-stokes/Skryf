use strict;
use warnings;
package App::skryf;

use Mojo::Base 'Mojolicious';
use Carp;
use File::ShareDir ':ALL';
use Path::Tiny;
use Mango;

our $VERSION = '0.009';

sub startup {
    my $self = shift;
    $self->secret("WHO CARES RITE?");
###############################################################################
# Setup configuration
###############################################################################
    my $cfgfile = path("~/.skryf.conf");

    path(dist_dir('App-skryf'), "skryf.conf")->copy($cfgfile)
      unless $cfgfile->exists;

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
    my $template_directory = $cfg->{template_directory};
    my $media_directory    = $cfg->{media_directory};
    my $static_directory   = $cfg->{static_directory};

    croak("A template|media|static directory must be defined.")
      unless $template_directory->is_dir
      && $media_directory->is_dir
      && $static_directory->is_dir;

    push @{$self->renderer->paths}, $template_directory;
    push @{$self->static->paths},   $media_directory;

###############################################################################
# Mongo setup
###############################################################################
    my $mango = Mango->new($cfg->{db}{dsn});
    my $dbc =
      $mango->db($cfg->{db}{name})
      ->collection($cfg->{db}{collection});
    $self->helper(db => sub {$dbc});

###############################################################################
# Configuration helper
###############################################################################
    $self->helper(cfg => sub {$cfg});

###############################################################################
# Routing
###############################################################################
    my $r = $self->routes;
    $r->get('/')->to('blog#index')->name('index');
    $r->get('/feeds/:category/atom.xml')->to('blog#feeds_by_cat')
      ->name('feeds_by_cat');
    $r->get('/atom.xml')->to('blog#feeds')->name('feeds');
    $r->get('/:slug')->to('blog#static_page')->name('static_page');
    $r->get('/post/:slug')->to('blog#post_page')->name('post_page');
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
