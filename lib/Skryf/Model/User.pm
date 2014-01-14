package Skryf::Model::User;

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

sub create {
    my ($self, $username, $password) = @_;
    my $user = $self->users->find_one({username => $username});
    if (!$user) {
        $self->users->insert(
            {   created  => DateTime->now,
                username => $username,
                password => $password
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

=head1 NAME

Skryf::Model::User - User Model Skryf

=head1 DESCRIPTION

User model 

=head1 METHODS

=head2 B<users>

Grabs user collection from Mongo

=head2 B<all>

Returns all users

=head2 B<check>

Checks username/password against database

=head2 B<create>

Creates a user

=head2 B<get>

Gets single user

=head2 B<remove>

Removes user

=head2 B<save>

Saves user and attributes

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
