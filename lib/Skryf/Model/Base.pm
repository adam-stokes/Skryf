package Skryf::Model::Base;
# ABSTRACT: Base model

use Mojo::Base -base;
use Mango;

has 'mpath' => 'mongodb://localhost:27017/';

has 'dbname' => sub {
    my $self = shift;
    my $_dbname = $ENV{TEST_ONLINE} || 'skryf';
    return $_dbname;
};

sub mgo {
    my $self = shift;
    return Mango->new($self->mpath . $self->dbname);
}

sub current_db {
    my $self = shift;
    return sprintf("%s%s", $self->mpath, $self->dbname);
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
