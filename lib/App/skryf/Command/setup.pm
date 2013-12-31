package App::skryf::Command::setup;

# VERSION

use Mojo::Base 'Mojolicious::Command';
use Mojo::Util qw(hmac_sha1_sum);
use FindBin '$Bin';
use Carp;
use IO::Prompt;
use App::skryf::Model::User;

has description => "Setup Skryf.\n";
has usage       => <<"EOF";

Usage: $0 setup

EOF

sub run {
    my ($self, @args) = @_;
    my $model = App::skryf::Model::User->new;

    say "Skryf Setup";
    my $username = prompt('Username: ', -tty);
    my $password = prompt('Password: ', -echo => '*', -tty);
    if ($model->get({username => $username})) {
        croak
          "The user: $username already exists in the database.\n",
          "Please remove if you wish to re-auth";
    }
    $model->create($username, hmac_sha1_sum($self->app->secrets->[0], $password));
    say "Skryf Setup completed.";
}
1;
