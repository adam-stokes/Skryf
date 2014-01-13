package Skryf::Model::Page;

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

=head1 NAME

Skryf::Model::Page - Page Model Skryf

=head1 DESCRIPTION

Page model

=head1 METHODS

=head2 B<pages>

Pages collection

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

