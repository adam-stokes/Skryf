package Skryf::Command::loadfixtures;
# ABSTRACT: loads fixtures from fixtures/<data>.json

use Mojo::Base 'Mojolicious::Commands';
use Mojo::JSON qw(decode_json encode_json);
use Skryf::DB;
use Path::Tiny;
use Carp;

has description => "Load fixtures into db\n";
has usage       => "usage: $0 loadfixtures [DBNAME]\n";

sub run {
    my $self = shift;
    my $dbname = $_[0] || undef;
    croak "Specify a DBNAME" unless defined $dbname;
    my $fixtures = path("fixtures/users.json")->slurp_utf8;
    my $json     = decode_json($fixtures);
    my $db       = Skryf::DB->new(dbname => $dbname);
    my $users    = $self->db->namspace('users');
    for my $i (@{$json->{users}}) {
        say "Adding user: " . $i->{username};
        $self->users->insert($i);
    }

}

1;
