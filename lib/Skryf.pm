package Skryf;
# ABSTRACT: Skryf application

use Mojo::Base 'Mojolicious';

use Carp;
use File::ShareDir ':ALL';
use File::chdir;
use Path::Tiny;
use Class::Load ':all';
use version;

sub startup {
    my $app = shift;

###############################################################################
# Skryf::Command namespace
###############################################################################
    push @{$app->commands->namespaces}, 'Skryf::Command';

###############################################################################
# Setup configuration
###############################################################################
    my $cfgfile = undef;
    if ($app->mode eq "development") {
        $cfgfile = path($CWD, "config/development.conf");
        path(dist_dir('Skryf'), 'config/development.conf')->copy($cfgfile)
          unless $cfgfile->exists;
    }
    elsif ($app->mode eq "staging") {
        $cfgfile = path($CWD, "config/staging.conf");
        path(dist_dir('Skryf'), 'config/production.conf')->copy($cfgfile)
          unless $cfgfile->exists;
    }
    else {
        $cfgfile = path($CWD, "config/production.conf");
        path(dist_dir('Skryf'), 'config/production.conf')->copy($cfgfile)
          unless $cfgfile->exists;
    }
    $app->plugin('Config' => {file => $cfgfile});
    $app->config->{version} = $Skryf::VERSION;
    $app->secrets($app->config->{secrets});

###############################################################################
# Authentication helpers
###############################################################################
    $app->helper(
        auth_fail => sub {
            my $self = shift;
            my $message = shift || "Not Authorized";
            $self->flash(message => $message);
            $self->redirect_to('login');
            return 0;
        }
    );
    $app->helper(
        is_admin => sub {
            my $self = shift;
            return 1 unless $self->session->{is_admin};
        }
    );

###############################################################################
# Load global plugins
###############################################################################
    push @{$app->plugins->namespaces}, 'Skryf::Plugin';
    for (keys %{$app->config->{plugins}}) {
        $app->log->debug('Loading plugin: ' . $_);
        $app->plugin($_) if $app->config->{plugins}{$_} > 0;
    }

###############################################################################
# Set renderer paths for template/static files
###############################################################################
    if ($app->config->{theme} !~ /static_site/) {
        push @{$app->renderer->paths}, 'templates';
        push @{$app->static->paths},   'public';

        # Load any custom theme specifics
        push @{$app->plugins->namespaces}, 'Skryf::Theme';
        $app->plugin($app->config->{theme}) if $app->config->{theme};
    }
    else {
        push @{$app->static->paths}, 'public';
    }

    # Fallback
    push @{$app->renderer->paths}, path(dist_dir('Skryf'), 'theme/templates');
    push @{$app->static->paths},   path(dist_dir('Skryf'), 'theme/public');

###############################################################################
# Routing
###############################################################################

    ###########################################################################
    # Authentication
    ###########################################################################
    my $r = $app->routes;
    $r->any(
        '/' => sub {
            my $self = shift;
            if ($self->config->{theme} =~ /static_site/) {
                $self->render_static($app->config->{landing_page});
            }
            else {
                if ($self->config->{landing_page}) {
                    $self->render($app->config->{landing_page});
                }
                else {
                    $self->render('welcome');
                }
            }
        }
    )->name('welcome');

    if ($app->config->{theme} !~ /static_site/) {
        $r->any('/login')->to('login#login');
        $r->any('/logout')->to('login#logout');
        $r->post('/auth')->to('login#auth');
    }

    ###########################################################################
    # Administration
    ###########################################################################
    my $if_admin = $r->under(
        sub {
            my $self = shift;
            return $self->auth_fail unless $self->is_admin;
        }
    );
    $if_admin->any('/admin/dashboard')->to('admin#dashboard');

    return;
}

1;

__END__

=head1 DESCRIPTION

easy does it web application development.

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

=cut
