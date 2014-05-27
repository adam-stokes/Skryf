package Skryf::Model::User;

# ABSTRACT: Skryf user model

use DateTime;
use Types::Standard qw(:all);

use Moo;
extends 'Skryf::DB';
use namespace::clean;

has 'collection' => (
  is => 'ro',
  isa => Str,
  lazy => 1,
  default => sub { 'users' }
);

sub save {
    my ($self, $params) = @_;
    $self->q->save($params);
}

sub find_user {
    my ($self, $doc) = @_;
    return $self->q->find_one({_id => $doc->{_id}}) if $doc->{_id};
    return $self->q->find_one($doc);
}

sub remove_user {
    my ($self, $doc) = @_;
    return $self->q->remove({_id => $doc->{_id}}) if $doc->{_id};
    return $self->q->remove($doc);
}

1;

__END__

=head1 DESCRIPTION

User model

=cut
