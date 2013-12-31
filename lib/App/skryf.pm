package App::skryf;

use Mojo::Base 'Mojolicious';

use Carp;
use File::ShareDir ':ALL';
use Path::Tiny;
use Class::Load ':all';
use DDP;

# VERSION

has admin_menu => sub {
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
        path(dist_dir('App-skryf'), 'app/config/production.conf')
          ->copy($cfgfile)
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
        $self->log->debug('Loading plugin: ' . $_);
        $self->plugin($_) if $self->config->{extra_modules}{$_} > 0;
    }

###############################################################################
# Make sure a theme is available and load it.
###############################################################################
    croak("No theme was defined/found.")
      unless defined($self->config->{theme});
    push @{$self->plugins->namespaces}, 'App::skryf::Theme';
    $self->log->debug('Loading theme: ' . $self->config->{theme});
    $self->plugin($self->config->{theme});

# use App::skryf::Command namespace
    push @{$self->commands->namespaces}, 'App::skryf::Command';

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
            $self->redirect_to($self->config->{landing_page});
        }
    )->name('welcome');
}
1;

__END__

=head1 NAME

App-skryf - Perl CMS/CMF.

=head1 DESCRIPTION

CMS/CMF platform for Perl.

=head1 METHODS

L<App::skryf> inherits all methods from
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
