package App::skryf::Model::User;

use Mojo::Base 'App::skryf::Model::Base';
use Method::Signatures;

method users {
    $self->mgo->db->collection('users');
}

method create ($username, $password) {
    my $user = $self->users->find_one({username => $username});
    if (!$user) {
        $self->users->insert(
            {   username => $username,
                password => $password,
            }
        );
    }
    return 1;
}

method get ($username) {
    $self->users->find_one({username => $username});
}

method remove ($username) {
    $self->users->remove({username => $username});
}

method check ($username, $password) {
    my $user = $self->users->find_one({username => $username});
    return 1 if $user->{password} eq $password;
    return undef;
}

1;
__END__

=head1 NAME

App::skryf::Model::User - User Model Skryf

=head1 DESCRIPTION

User model 

=head1 METHODS

=head2 B<users>

Grabs user collection from Mongo

=head2 B<check>

Checks username/password against database

=head2 B<create>

Creates a user

=head2 B<get>

Gets single user

=head2 B<remove>

Removes user

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
