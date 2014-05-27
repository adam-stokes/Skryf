package Skryf::DB;

# ABSTRACT: database connection

use Mango;
use Module::Runtime qw(use_module);
use Moo;
use Types::Standard qw(:all);
use namespace::clean;

has 'mpath' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { 'mongodb://localhost:27017/' }
);

has 'dbname' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { $ENV{TEST_ONLINE} || 'skryf' }
);

has 'mgo' => (
    is      => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        return Mango->new($self->mpath . $self->dbname);
    }
);

has 'collection' => (
  is => 'ro',
  isa => Str,
  lazy => 1,
  required => 1,
  default => sub { 'test' }
);

sub q {
    my ($self, $name) = @_;
    $self->mgo->db->collection($self->collection);
}

sub model {
    my ($self, $name) = @_;
    return use_module($name)->new;
}

1;
