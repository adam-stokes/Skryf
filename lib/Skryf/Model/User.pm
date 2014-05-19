package Skryf::Model::User;

# ABSTRACT: Skryf user model

use DateTime;

use Moo;
extends 'Skryf::Model::Base';
use namespace::clean;

sub BUILD {
    my $self = shift;
    $self->namespace('users');
}

sub create {
    my ($self, $username, $password) = @_;
    my $user = $self->get({username => $username});
    if (!$user) {
        $self->q->insert(
            {   created  => DateTime->now,
                username => $username,
                password => $password,
                roles    => +{},
            }
        );
    }
    return 1;
}

1;

__END__

=head1 DESCRIPTION

User model

=method users

Grabs user collection from Mongo

=method all

Returns all users

=method check

Checks username/password against database

=method create

Creates a user

=method get

Gets single user

=method remove

Removes user

=method save

Saves user and attributes

=cut
