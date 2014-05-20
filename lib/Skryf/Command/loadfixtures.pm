package Skryf::Command::loadfixtures;
# ABSTRACT: loads fixtures from fixtures/<data>.json

use Mojo::Base 'Mojolicious::Commands';
use Mojo::JSON qw(decode_json encode_json);
use Mojo::Util qw(hmac_sha1_sum);
use Skryf::DB;
use Path::Tiny;
use Carp;

has description => "Load fixtures into db\n";
has usage       => "usage: $0 loadfixtures [DBNAME] <fixtures.json>\n";

sub run {
    my $self = shift;
    my $dbname = $_[0] || undef;
    my $fixturepath = $_[1] || undef;
    croak "Specify a DBNAME" unless defined $dbname;
    croak "Specify a fixture path" unless defined $fixturepath;
    my $fixtures = path($fixturepath)->slurp_utf8;
    my $json     = decode_json($fixtures);
    my $db       = Skryf::DB->new(dbname => $dbname);
    my $users    = $db->namespace('users');
    for my $i (@{$json->{users}}) {
        say "Adding user: " . $i->{username};
        $i->{password} =
          hmac_sha1_sum('this sentence would be a secret.', $i->{password});
        $users->insert($i);
    }

}

1;
