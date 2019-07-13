package Skryf::Command::new;

# ABSTRACT: Start a new skryf application

use Mojo::Base 'Mojolicious::Commands';
use Mojo::Util qw(hmac_sha1_sum);
use Mojo::UserAgent;
use Mojo::Template;
use File::ShareDir ':ALL';
use File::chdir;
use File::Copy::Recursive qw[fcopy dircopy];
use Carp;
use Path::Tiny;
use IO::Prompt;
use DateTime;
use Skryf::DB;

has description => "Create a new Skryf application.\n";
has usage       => "usage: $0 new [NAME]\n";
has attrs       => sub { my $self = shift; return {} };
has mt          => sub { my $self = shift; Mojo::Template->new; };

sub run {
    my $self     = shift;
    my $app_name = $_[0] || undef;

    say "Skryf Setup ...";
###############################################################################
    # Setup application and copy over skeleton
###############################################################################
    $app_name = prompt( 'Application name: ', -tty ) unless defined $app_name;
    $self->attrs->{site} =
      prompt( -default => 'http://localhost', -tty, 'Site host: ' );
    $self->attrs->{site_port} =
      prompt( -default => '3000', -tty, 'Site port: ' );
    $self->attrs->{site_title} =
      prompt( -default => 'Perl on web.', -tty, 'Site title: ' );
    $self->attrs->{site_author} =
      prompt( -default => 'hackr', -tty, 'Owner name: ' );
    $self->attrs->{site_contact} =
      prompt( -default => 'hackr@ownz.me', -tty, 'Owner email: ' );
    $self->attrs->{site_desc} =
      prompt( -default => 'a tagline site.', -tty, 'Site description: ' );
    $self->attrs->{site_secret} = prompt(
        -default => 'this sentence would be a secret.',
        -tty, 'Site Secret: '
    );
    my $app_name_p = path($app_name);

    if ( $app_name_p->exists ) {
        croak
          "The application directory: $app_name exists. \n",
          "Please create a new application",
          "or remove the existing one to proceed.\n";
    }
    else {
        $app_name_p->child('config')->mkpath    or die $!;
        $app_name_p->child('templates')->mkpath or die $!;
        $app_name_p->child('public')->mkpath    or die $!;
        $app_name_p->child('logs')->mkpath      or die $!;

        for my $_conf (qw/production staging development/) {
            $self->attrs->{dbname} = sprintf( "%s_%s", $app_name, $_conf );

            # Render configs with the entered data
            my $rendered_conf = $self->mt->render_file(
                path( dist_dir('Skryf'), 'config/development.conf' ),
                $self->attrs );

            $app_name_p->child( sprintf( "config/%s.conf", $_conf ) )
              ->spew_utf8($rendered_conf);
        }

        fcopy( path( dist_dir('Skryf'), 'app.pl' ),
            $app_name_p->child('app.pl') );
    }

###############################################################################
    # Setup database and user credentials
###############################################################################
    $self->app->secrets->[0] = $self->attrs->{site_secret};
    say "Database($app_name) configuration ...";
    my $username = prompt( 'Administrator login: ',    -tty );
    my $password = prompt( 'Administrator password: ', -echo => '*', -tty );

    for my $env (qw/production staging development/) {
        my $db =
          Skryf::DB->new( dbname => sprintf( "%s_%s", $app_name, $env ) );
        my $users =
          $db->namespace('users')->find_one( { username => $username } );
        if ($users) {
            croak
              "The user: $username already exists in the $env database.\n",
              "Please remove if you wish to re-auth";
        }
        printf( "Creating user in %s_%s ..\n", $app_name, $env );
        $db->namespace('users')->save(
            {
                created  => DateTime->now,
                username => $username,
                password =>
                  hmac_sha1_sum( $self->app->secrets->[0], $password ),
                roles => {
                    admin => {
                        is_staff => 1,
                        is_owner => 1
                    }
                },
                domain => $self->attrs->{site}
            }
        );
    }

    say "Setting permissions";
    system( "find " . $app_name_p . " -type f | xargs chmod u+rw" );
    system( "find " . $app_name_p . " -type d | xargs chmod u+r" );
    say "Skryf Setup completed.";
}

1;
