package Skryf::Model::Page;
# ABSTRACT: Skryf page model

use Skryf::Util;
use DateTime;

use constant USE_WIKILINKS => 1;

use Moo;
use namespace::clean;

sub create {
    my ($self, $slug, $content, $created) = @_;
    $created = DateTime->now unless $created;
    my $html = Skryf::Util->convert($content, USE_WIKILINKS);
    my $created_new = $created->strftime('%Y-%m-%dT%H:%M:%SZ'),
}

sub save {
    my ($self, $page) = @_;
    my $lt = DateTime->now;
    $page->{html} =
      Skryf::Util->convert($page->{content}, USE_WIKILINKS);
    $page->{modified} = $lt->strftime('%Y-%m-%dT%H:%M:%SZ');
}

1;

__END__

=head1 DESCRIPTION

Page model

=cut

