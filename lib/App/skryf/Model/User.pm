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

=head1 Model Attributes

The user model contains these attributes

=over 8

=item Username

=item Password

=item Disqus

=item GooglePlus

=item Stackoverflow

=item GoogleAnalytics

=item Coderwall

=item Github

=back

=cut
