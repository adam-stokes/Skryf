package Skryf;

use Mojo::Base 'Mojolicious';

use Carp;
use File::ShareDir ':ALL';
use File::chdir;
use Path::Tiny;
use Class::Load ':all';
use DDP;

our $VERSION = '0.99_3';

sub startup {
    my $self = shift;
    p @INC;
###############################################################################
# Skryf::Command namespace
###############################################################################
    push @{$self->commands->namespaces}, 'Skryf::Command';

###############################################################################
# Setup configuration
###############################################################################
    my $cfgfile = undef;
    if ($self->mode eq "development") {
        $cfgfile = path($CWD, "config/development.conf");
        path(dist_dir('Skryf'), 'config/development.conf')->copy($cfgfile)
          unless $cfgfile->exists;
    }
    elsif ($self->mode eq "staging") {
        $cfgfile = path($CWD, "config/staging.conf");
        path(dist_dir('Skryf'), 'config/production.conf')->copy($cfgfile)
          unless $cfgfile->exists;
    }
    else {
        $cfgfile = path($CWD, "config/production.conf");
        path(dist_dir('Skryf'), 'config/production.conf')->copy($cfgfile)
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
            my $store      = "models::$collection";
            load_class($store);
            $store->new(dbname => $self->config->{dbname});
        }
    );

###############################################################################
# Load global plugins
###############################################################################
    push @{$self->plugins->namespaces}, 'Skryf::Plugin';
    for (keys %{$self->config->{plugins}}) {
        $self->log->debug('Loading plugin: ' . $_);
        $self->plugin($_) if $self->config->{plugins}{$_} > 0;
    }

###############################################################################
# Set renderer paths for template/static files
###############################################################################
    push @{$self->renderer->paths}, 'templates';
    push @{$self->static->paths},   'public';

###############################################################################
# Routing
###############################################################################
    my $r = $self->routes;

    # Default route
    $r->get('/login')->to('login#login')->name('login');
    $r->get('/logout')->to('login#logout')->name('logout');
    $r->post('/auth')->to('login#auth')->name('auth');

    $r->get('/')->to(
        cb => sub {
            my $self = shift;
            if ($self->config->{landing_page}) {
                $self->render($self->config->{landing_page});
            }
            else {
                $self->render('welcome');
            }
        }
    )->name('welcome');
}
1;

__END__

=head1 NAME

Skryf - Perl on web.

=head1 DESCRIPTION

Perl on web platform.

=head1 PREREQS

Perl 5.14 or higher, L<App::cpanminus> >= 1.7102, and Mongo.

=head1 INSTALL

    $ cpanm git@github.com:skryf/Skryf.git
    $ skryf new [NAME]
    $ cd [NAME]
    $ carton install
    $ carton exec morbo app.pl

=head1 METHODS

L<Skryf> inherits all methods from
L<Mojolicious> and overloads the following:

=head2 startup

This is your main hook into the application, it will be called at
application startup. Meant to be overloaded in a subclass.

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013-2014 Adam Stokes

=head1 LICENSE

Licensed under the same terms as Perl.

=cut
