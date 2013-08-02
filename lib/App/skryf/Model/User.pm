package App::skryf::Model::User;

use Mojo::Base 'App::skryf::Model::Base';
use Method::Signatures;

method check ($username, $password) {
    my $user = $self->db->find_one({username => $username});
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
