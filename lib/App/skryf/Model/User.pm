use strict;
use warnings;

package App::skryf::Model::User;

use Mojo::Base -base;
use Data::Printer;

has [
    qw(username
      password
      disqus
      googleplus
      stackoverflow
      googleanalytics
      coderwall
      github
      db)
] => sub {};

sub check {
    my ($self, $password) = @_;
    my $user = $self->db->find_one({username => $self->username});
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
