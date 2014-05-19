package Skryf::Model::Base;

# ABSTRACT: Base model

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

sub current_db {
    my $self = shift;
    return sprintf("%s%s", $self->mpath, $self->dbname);
}

sub all {
    my $self = shift;
    $self->q->find()->all;
}

sub get {
    my ($self, $key, $value) = @_;
    $self->q->find_one({$key => $value});
}

sub remove {
    my ($self, $key, $value) = @_;
    $self->q->remove({$key => $value});
}

sub save {
    my ($self, $attrs) = @_;
    $self->q->save($attrs);
}

sub search {
    my ($self, $kwds) = @_;
    $self->q->find({content => qr/$kwds/})->all;
}


1;
__END__

=head1 DESCRIPTION

Base model and is usually inherited by other models specific to the storage
type.

=attr mpath

MongoDB connection URI.

=attr dbname

MongoDB name.

=method mgo

The connection method for all inherited model types.

=method current_db

The currently used database.

=cut
