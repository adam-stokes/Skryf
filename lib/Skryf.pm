package Skryf;

# ABSTRACT: Skryf application

our $VERSION = '2';
use Mojo::Base 'Mojolicious';

use Carp;
use File::ShareDir ':ALL';
use File::chdir;
use Path::Tiny;
use Class::Load ':all';
use version;
use Skryf::DB;

sub startup {
    my $app = shift;

###############################################################################
    # Skryf::Command namespace
###############################################################################
    push @{ $app->commands->namespaces }, 'Skryf::Command';

###############################################################################
    # Setup configuration
###############################################################################
    my $cfgfile = undef;
    if ( $app->mode eq "development" ) {
        $cfgfile = path( $CWD, "config/development.conf" );
        path( dist_dir('Skryf'), 'config/development.conf' )->copy($cfgfile)
          unless $cfgfile->exists;
    }
    elsif ( $app->mode eq "staging" ) {
        $cfgfile = path( $CWD, "config/staging.conf" );
        path( dist_dir('Skryf'), 'config/production.conf' )->copy($cfgfile)
          unless $cfgfile->exists;
    }
    else {
        $cfgfile = path( $CWD, "config/production.conf" );
        path( dist_dir('Skryf'), 'config/production.conf' )->copy($cfgfile)
          unless $cfgfile->exists;
    }
    $app->plugin( 'Config' => { file => $cfgfile } );
    $app->config->{version} = $Skryf::VERSION;
    $app->secrets( $app->config->{secrets} );

###############################################################################
    # Load core and any additional namespaces
###############################################################################
    push @{ $app->plugins->namespaces }, 'Skryf::Plugin';
    push @{ $app->plugins->namespaces }, 'Skryf::Theme';

    # Add additional namespaces if configured
    for ( @{ $app->config->{namespaces} } ) {
        $app->log->debug( 'Adding namespace: ' . $_ );
        push @{ $app->plugins->namespaces }, $_ . '::Plugin';
        push @{ $app->plugins->namespaces }, $_ . '::Theme';
    }

###############################################################################
    # Load global plugins
###############################################################################
    for ( keys %{ $app->config->{plugins} } ) {
        $app->log->debug( 'Loading plugin: ' . $_ );
        $app->plugin($_) if $app->config->{plugins}{$_} == 1;
    }

###############################################################################
    # Set renderer paths for template/static files
###############################################################################
    push @{ $app->renderer->paths }, 'templates';
    push @{ $app->static->paths },   'public';

    # Load any custom theme specifics
    $app->plugin( $app->config->{theme} ) if $app->config->{theme};

    # Fallback
    push @{ $app->renderer->paths },
      path( dist_dir('Skryf'), 'theme/templates' );
    push @{ $app->static->paths }, path( dist_dir('Skryf'), 'theme/public' );

###############################################################################
    # Helpers
###############################################################################
    $app->helper(
        db => sub {
            my $self = shift;
            Skryf::DB->new( dbname => $self->config->{dbname} );
        }
    );

    $app->helper(
        get_user => sub {
            my $self     = shift;
            my $username = shift;
            return $self->db->namespace('users')
              ->find_one( { username => $username } );
        }
    );

    $app->helper(
        auth_role_fail => sub {
            my $self = shift;
            $self->flash( message => 'Incorrect permission for this section' );
            $self->redirect_to('login');
        }
    );

    $app->helper(
        auth_has_role => sub {
            my $self = shift;
            my $k    = shift;
            my $v    = shift;
            my $user = $self->get_user( $self->session->{username} );
            return $user->{roles}->{$k}->{$v};
        }
    );

###############################################################################
    # Routing
###############################################################################
    my $r = $app->routes;

    # Admin
    my $if_admin = $app->routes->under(
        sub {
            my $self = shift;
            return $self->auth_role_fail
              unless $self->auth_has_role( 'admin', 'is_staff' );
        }
    );

    $if_admin->any('/admin')->to('admin#dashboard')->name('admin_dashboard');
    $if_admin->any('/admin/settings')->to('admin#site_settings')
      ->name('admin_site_settings');

    $if_admin->any('/admin/users')->to('admin#users')->name('admin_users');
    $if_admin->any('/admin/users/modify/:username')->to('admin#modify_user')
      ->name('admin_users_modify');
    $if_admin->any('/admin/users/delete/:username')->to('admin#delete_user')
      ->name('admin_users_delete');

    # Authentication
    $r->any('/login')->to('auth#login');
    $r->any('/logout')->to('auth#logout');
    $r->post('/authenticate')->to('auth#verify');

    $r->any(
        '/' => sub {
            my $self = shift;
            if (   $self->config->{theme}
                && $self->config->{theme} =~ /static_site/ )
            {
                $self->render_static( $app->config->{landing_page} );
            }
            else {
                if ( $self->config->{landing_page} ) {
                    $self->render( $app->config->{landing_page} );
                }
                else {
                    $self->render('welcome');
                }
            }
        }
    )->name('welcome');

    return;
}

1;

__END__

=head1 DESCRIPTION

easy does it web application development.

=head1 PREREQS

Perl 5.18+ and Mongo 2.6+.

=head1 INSTALL

    $ cpanm git@github.com:skryf/Skryf.git
    $ skryf new [NAME]
    $ cd [NAME]
    $ morbo app.pl

=head1 METHODS

L<Skryf> inherits all methods from
L<Mojolicious> and overloads the following:

=head2 startup

This is your main hook into the application, it will be called at
application startup. Meant to be overloaded in a subclass.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=cut
