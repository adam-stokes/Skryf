package App::skryf::Command::setup;

use Mojo::Base 'Mojolicious::Command';
use FindBin '$Bin';
use Carp;
use IO::Prompt;

has description => "Setup your CMS.\n";
has usage       => <<"EOF";

Usage: $0 setup

EOF

sub run {
    my ($self, @args) = @_;
    use Data::Printer;
    p(@args);
    my $model = $self->app->db('User');

    say "CMS Setup";
    my $username = prompt('Username: ', -tty);
    my $password = prompt('Password: ', -echo => '*', -tty);
    if ($model->get({username => $username})) {
        croak
          "The user: $username already exists in the database.\n",
          "Please remove if you wish to re-auth";
    }
    $model->create($username, $self->app->bcrypt($password));
    say "CMS Setup completed.";
}
1;
