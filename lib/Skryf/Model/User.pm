package Skryf::Model::User;

# ABSTRACT: Skryf user model

use Mojo::Base 'Skryf::Model::Base';
use Mojo::Util qw(hmac_sha1_sum);
use DateTime;

sub users {
    my $self = shift;
    $self->mgo->db->collection('users');
}

sub all {
    my $self = shift;
    $self->users->find()->all;
}

sub roles {
    my ($self, $username) = @_;
    my $user = $self->get($username);
    return $user->{roles};
}

sub create {
    my ($self, $username, $password) = @_;
    my $user = $self->users->find_one({username => $username});
    if (!$user) {
        $self->users->insert(
            {   created  => DateTime->now,
                username => $username,
                password => $password,
                roles    => [qw/Subscriber/],
            }
        );
    }
    return 1;
}

sub get {
    my ($self, $username) = @_;
    $self->users->find_one({username => $username});
}

sub remove {
    my ($self, $username) = @_;
    $self->users->remove({username => $username});
}

sub save {
    my ($self, $user) = @_;
    $self->users->save($user);
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
