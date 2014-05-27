package Skryf::Model::Page;
# ABSTRACT: Skryf page model

use Skryf::Util;
use Types::Standard qw(:all);
use DateTime;

use constant USE_WIKILINKS => 1;
use Moo;
extends 'Skryf::DB';
use namespace::clean;

has 'collection' => (
  is => 'ro',
  isa => Str,
  lazy => 1,
  default => sub { 'pages' }
);

sub save {
    my ($self, $params) = @_;
    my $created = $params->{created} // DateTime->now;
    $params->{html} = Skryf::Util->convert($params->{content}, USE_WIKILINKS);
    $params->{created} = $created->strftime('%Y-%m-%dT%H:%M:%SZ');
    $self->q->save($params);
}

sub find_page {
  my ($self, $doc) = @_;
  return $self->q->find_one({_id => $doc->{_id}}) if $doc->{_id};
  return $self->q->find_one($doc);
}

sub remove_page {
  my ($self, $doc) = @_;
  return $self->q->remove({_id => $doc->{_id}}) if $doc->{_id};
  return $self->q->remove($doc);
}

1;

__END__

=head1 DESCRIPTION

Page model

=cut

