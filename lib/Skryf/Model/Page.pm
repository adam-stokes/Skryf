package Skryf::Model::Page;
# ABSTRACT: Skryf page model


use Skryf::Util;
use DateTime;

use constant USE_WIKILINKS => 1;

use Moo;
extends 'Skryf::Model::Base';
use namespace::clean;

sub BUILD {
    my $self = shift;
    $self->namespace('pages');
}

sub create {
    my ($self, $slug, $content, $created) = @_;
    $created = DateTime->now unless $created;
    my $html = Skryf::Util->convert($content, USE_WIKILINKS);
    $self->q->insert(
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
    $self->q->save($page);
}

1;

__END__

=head1 DESCRIPTION

Page model

=method pages

Pages collection

=cut

