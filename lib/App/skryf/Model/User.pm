use strict;
use warnings;

package App::skryf::Model::User;

use Mojo::Base -base;

has [
    qw(username
      password
      disqus
      googleplus
      stackoverflow
      googleanalytics
      coderwall
      github
      orig)
] => sub {};
has db => sub {};

sub _merge {
    my ($self) = @_;
    $self->disqus($self->orig->{disqus});
    $self->googleplus($self->orig->{googleplus});
    $self->stackoverflow($self->orig->{stackoverflow});
    $self->googleanalytics($self->orig->{googleanalytics});
    $self->coderwall($self->orig->{coderwall});
    $self->github($self->orig->{github});
    $self->username($self->orig->{username});
    $self->password($self->orig->{password});
}

sub check {
    my ($self, $password) = @_;
    $self->one;
    if ($self->username) {
      return 1 if $self->password eq $password;
    }
    return undef;
}

sub one {
    my ($self) = @_;
    $self->orig($self->db->find_one({username => $self->username}));
    if ($self->orig) {
        $self->_merge;
    }
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
