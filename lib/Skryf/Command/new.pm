package Skryf::Command::new;

our $VERISON = '0.99_3';

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
use Skryf::Model::User;

eval Mojo::UserAgent->new->get('https://raw.github.com/miyagawa/cpanminus/devel/cpanm')->res->body;
require App::cpanminus;

has description => "Create a new Skryf application.\n";
has usage       => "usage: $0 new [NAME]\n";
has attrs => sub { my $self = shift; return {} };
has mt => sub { my $self = shift; Mojo::Template->new; };

sub run {
    my $self = shift;
    my $app_name = $_[0] || undef;

    say "Skryf Setup ...";
###############################################################################
# Setup application and copy over skeleton
###############################################################################
    $app_name = prompt('Application name: ', -tty) unless defined $app_name;
    $self->attrs->{site} =
      prompt(-default => 'http://localhost', -tty, 'Site host: ');
    $self->attrs->{site_title} =
      prompt(-default => 'Perl on web.', -tty, 'Site title: ');
    $self->attrs->{site_author} =
      prompt(-default => 'hackr', -tty, 'Owner name: ');
    $self->attrs->{site_contact} =
      prompt(-default => 'hackr@ownz.me', -tty, 'Owner email: ');
    $self->attrs->{site_desc} =
      prompt(-default => 'a tagline site.', -tty, 'Site description: ');
    my $app_name_p = path($app_name);

    if ($app_name_p->exists) {
        croak
          "The application directory: $app_name exists. Please create a new application",
          "or remove the existing one to proceed.\n";
    }
    else {
        $app_name_p->child('config')->mkpath or die $!;

        for my $_conf (qw/production staging development/) {
            $self->attrs->{dbname} = sprintf("%s_%s", $app_name, $_conf);

            # Render configs with the entered data
            my $rendered_conf = $self->mt->render_file(
                path(dist_dir('Skryf'), 'config/development.conf'),
                $self->attrs);

            $app_name_p->child(sprintf("config/%s.conf", $_conf))
              ->spew_utf8($rendered_conf);
        }
        $app_name_p->child('models')->mkpath or die $!;

        # copy templates
        dircopy(path(dist_dir('Skryf'), 'theme/templates'),
            $app_name_p->child('templates'));

        # copy theme
        dircopy(path(dist_dir('Skryf'), 'theme/public'),
            $app_name_p->child('public'));
        fcopy(path(dist_dir('Skryf'), 'app.pl'),
            $app_name_p->child('app.pl'));
        fcopy(
            path(dist_dir('Skryf'), 'cpanfile'),
            $app_name_p->child('cpanfile')
        );
    }

###############################################################################
# Setup database and user credentials
###############################################################################
    my $model = Skryf::Model::User->new(dbname => $app_name);
    say "Database($app_name) configuration ...";
    my $username = prompt('Administrator login: ', -tty);
    my $password = prompt('Administrator password: ', -echo => '*', -tty);
    if ($model->get($username)) {
        croak
          "The user: $username already exists in the database.\n",
          "Please remove if you wish to re-auth";
    }
    $model->create($username,
        hmac_sha1_sum($self->app->secrets->[0], $password));

###############################################################################
# Install required dependencies from cpan
###############################################################################
    say "Installing dependencies ...";

   # XXX: just until these guys are out of development phase to support git://
    my $cpanm = App::cpanminus::script->new;
    $cpanm->{argv} =
      ['App::cpanminus@1.7102', 'Module::CPANfile@1.0905', 'Carton@1.0.901'];
    $cpanm->doit;
    say "Setting permissions";
    system("find " . $app_name_p . " -type f | xargs chmod u+rw");
    system("find " . $app_name_p . " -type d | xargs chmod u+r");
    say '-' x 79;
    say "Skryf Setup completed.";
}

1;
