package Skryf::Command::new;

# VERSION

use Mojo::Base 'Mojolicious::Commands';
use Mojo::Util qw(hmac_sha1_sum);
use Mojo::UserAgent;
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

sub run {
    my $self = shift;
    my $app_name = $_[0] || undef;

    say '-' x 79;
    say "Skryf Setup";
    say '-' x 79;
    $app_name = prompt('Application name: ', -tty) unless defined $app_name;
    my $app_name_p = path($app_name);
    if ($app_name_p->exists) {
        croak
          "The application directory: $app_name exists. Please create a new application",
          "or remove the existing one to proceed.\n";
    }
    else {
        $app_name_p->mkpath or die $!;
        $app_name_p->child('models')->mkpath or die $!;

        # copy templates
        dircopy(path(dist_dir('Skryf'), 'theme/templates'),
            $app_name_p->child('templates'));

        # copy configs
        dircopy(path(dist_dir('Skryf'), 'config'),
            $app_name_p->child('config'));

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
    my $model = Skryf::Model::User->new(dbname => $app_name);
    say '-' x 79;
    say "Database($app_name) configuration";
    say '-' x 79;
    my $username = prompt('Administrator login: ', -tty);
    my $password = prompt('Administrator password: ', -echo => '*', -tty);
    if ($model->get($username)) {
        croak
          "The user: $username already exists in the database.\n",
          "Please remove if you wish to re-auth";
    }
    $model->create($username,
        hmac_sha1_sum($self->app->secrets->[0], $password));

    say '-' x 79;
    say "Installing dependencies ...";

   # XXX: just until these guys are out of development phase to support git://
    my $cpanm = App::cpanminus::script->new;
    $cpanm->{argv} =
      ['App::cpanminus@1.7102', 'Module::CPANfile@1.0905', 'Carton@1.0.901'];
    $cpanm->doit or exit(1);
    say '-' x 79;
    say "Skryf Setup completed.";
}

1;
