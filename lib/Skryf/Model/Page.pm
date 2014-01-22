package Skryf::Model::Page;
# ABSTRACT: Skryf page model

use Mojo::Base 'Skryf::Model::Base';

use Skryf::Util;
use DateTime;

use constant USE_WIKILINKS => 1;

sub pages {
    my $self = shift;
    $self->mgo->db->collection('pages');
}

sub all {
    my $self = shift;
    $self->pages->find->sort({created => -1})->all;
}

sub get {
    my ($self, $slug) = @_;
    $self->pages->find_one({slug => $slug});
}

sub create {
    my ($self, $slug, $content, $created) = @_;
    $created = DateTime->now unless $created;
    my $html = Skryf::Util->convert($content, USE_WIKILINKS);
    $self->pages->insert(
        {   slug    => $slug,
            content => $content,
            created => $created->strftime('%Y-%m-%dT%H:%M:%SZ'),
            html    => $html,
        }
    );
}

sub save {
    my ($self, $page) = @_;
    my $lt = DateTime->now;
    $page->{html} =
      Skryf::Util->convert($page->{content}, USE_WIKILINKS);
    $page->{modified} = $lt->strftime('%Y-%m-%dT%H:%M:%SZ');
    $self->pages->save($page);
}

sub remove {
    my ($self, $slug) = @_;
    $self->pages->remove({slug => $slug});
}

sub search {
    my ($self, $kwds) = @_;
    $self->pages->find({content => qr/$kwds/})->all;
}

1;

__END__

=head1 DESCRIPTION

Page model

=method pages

Pages collection

=cut

