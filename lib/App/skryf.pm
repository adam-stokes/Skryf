package App::skryf;

use Mojo::Base 'Mojolicious';

use Carp;
use File::ShareDir ':ALL';
use Path::Tiny;
use Class::Load ':all';

# VERSION

has admin_menu => sub {
  my $self = shift;
  return [];
};

has frontend_menu => sub {
  my $self = shift;
  return [];
};

sub startup {
    my $self = shift;

###############################################################################
# Setup configuration
###############################################################################
    my $cfgfile = undef;
    if ($self->mode eq "development") {
        $cfgfile = path(dist_dir('App-skryf'), 'app/config/development.conf');
    }
    else {
        $cfgfile = path("~/.skryf.conf");
        path(dist_dir('App-skryf'), 'app/config/production.conf')->copy($cfgfile)
          unless $cfgfile->exists;
    }
    $self->plugin('Config' => {file => $cfgfile});
    $self->config->{version} = eval $VERSION;
    $self->secrets($self->config->{secret});

###############################################################################
# Database Helper
###############################################################################
    $self->helper(
        db => sub {
            my $self       = shift;
            my $collection = shift;
            my $store      = "App::skryf::Model::$collection";
            load_class($store);
            $store->new(dbname => $self->config->{dbname});
        }
    );
###############################################################################
# Load global plugins
###############################################################################
    push @{$self->plugins->namespaces}, 'App::skryf::Plugin';
    for (keys %{$self->config->{extra_modules}}) {
        $self->plugin($_) if $self->config->{extra_modules}{$_} > 0;
    }

###############################################################################
# Make sure a theme is available
###############################################################################
    croak("No theme was defined/found.")
      unless defined($self->config->{theme});

# use App::skryf::Command namespace
    push @{$self->commands->namespaces}, 'App::skryf::Command';

###############################################################################
# Routing
###############################################################################
    my $r = $self->routes;
    # Default route
    $r->get('/')->to('welcome#index')->name('welcome');
}
1;

__END__

=head1 NAME

App-skryf - Perl CMS/CMF.

=head1 DESCRIPTION

Another CMS platform which utilizes Mojolicious, Markdown, hypnotoad, Rex, Ubic,
and Mongo.

=head1 PREREQS

L<http://perlbrew.pl> or L<https://github.com/tokuhirom/plenv/>.

=head1 INSTALLATION (BLEEDING EDGE)

    $ cpanm git://github.com/battlemidget/App-skryf.git

=head1 SETUP

    $ skryf setup

By default B<skryf> will look in dist_dir for templates and media. To override that
make sure I<~/.skryf.conf> points to the locations of your templates and media.
For example: 

    $ mkdir -p ~/blog/{templates,public}

Edit ~/.skryf.conf to reflect those directories in I<template_directory> and 
I<media_directory>.

    template_directory => '~/blog/templates',
    media_directory    => '~/blog/public',

So B<~/blog/templates/blog/detail.html.ep> and B<~/blog/public/style.css>

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

=head1 LICENSE

Licensed under the same terms as Perl.

=cut
