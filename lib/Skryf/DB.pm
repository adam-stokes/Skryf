package Skryf::DB;

# ABSTRACT: database connection

use Mojo::Base -base;
use Mango;

has 'mpath'  => 'mongodb://localhost:27017/';
has 'dbname' => $ENV{TEST_ONLINE} // 'skryf';
has 'mgo' =>
  sub { my $self = shift; return Mango->new( $self->mpath . $self->dbname ); };

sub namespace {
    my ( $self, $name ) = @_;
    $self->mgo->db->collection($name);
}

1;
