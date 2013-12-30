package App::skryf::Model::Page;

# VERSION

use Mojo::Base 'App::skryf::Model::Base';

use App::skryf::Util;
use Method::Signatures;
use DateTime;

use constant USE_WIKILINKS => 1;

method pages {
    $self->mgo->db->collection('pages');
}

method all {
    $self->pages->find->sort({created => -1})->all;
}

method get ($slug) {
    $self->pages->find_one({slug => $slug});
}

method create ($slug, $content, $created = DateTime->now) {
    my $html = App::skryf::Util->convert($content, USE_WIKILINKS);
    $self->pages->insert(
        {   slug    => $slug,
            content => $content,
            created => $created->strftime('%Y-%m-%dT%H:%M:%SZ'),
            html    => $html,
        }
    );
}

method save ($page) {
    my $lt = DateTime->now;
    $page->{html} =
      App::skryf::Util->convert($page->{content}, USE_WIKILINKS);
    $page->{modified} = $lt->strftime('%Y-%m-%dT%H:%M:%SZ');
    $self->pages->save($page);
}

method remove ($slug) {
    $self->pages->remove({slug => $slug});
}

method search ($kwds) {
    $self->pages->find({content => qr/$kwds/})->all;
}

1;
__END__

=head1 NAME

App::skryf::Model::Page - Page Model Skryf

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

