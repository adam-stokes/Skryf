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

=attr q

Holds the collection methods

=cut
has 'q' => (
    is   => 'rw',
    lazy => 1,
);

has namespace => (
    is      => 'rw',
    trigger => sub {
        my ($self, $name) = @_;
        $self->q($self->mgo->db->collection($name));
    }
);

1;
