package Skryf::DB;

# ABSTRACT: database connection

use Mango;

use Moo;
use namespace::clean;

has 'mpath' => (
    is      => 'ro',
    default => sub {'mongodb://localhost:27017/'},
);

has 'dbname' => (
    is      => 'ro',
    default => sub {
        my $self = shift;
        $ENV{TEST_ONLINE} || 'skryf';
    },
);

has 'mgo' => (
    is   => 'ro',
    lazy => 1,
    default =>
      sub { my $self = shift; Mango->new($self->mpath . $self->dbname); },
);

has namespace => (
    is      => 'rw',
    trigger => sub {
        my ($self, $name) = @_;
        $self->mgo->db->collection($name);
    }
);

1;
