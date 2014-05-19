package Skryf::Model::Base;

# ABSTRACT: Base model

use Moo;
use namespace::clean;

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
