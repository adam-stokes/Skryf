package Skryf::Model::Blog;

use Mojo::Base 'Skryf::Model::Base';
use Skryf::Util;
use DateTime;

our $VERSION = '0.03';

sub posts {
    my $self = shift;
    $self->mgo->db->collection('posts');
}

sub all {
    my $self = shift;
    $self->posts->find->sort({created => -1})->all;
}

sub this_year {
    my ($self, $limit) = @_;
    $limit = 5 unless $limit;
    my $year = DateTime->now->year;
    $self->posts->find({created => qr/$year/})->sort({created => -1})
      ->limit($limit)->all;
}

sub by_year {
    my ($self, $year, $limit) = @_;
    $year = DateTime->now->year unless $year;
    $limit = -1 unless $limit;
    $self->posts->find({created => qr/$year/})->sort({created => -1})
      ->limit($limit)->all;
}

sub get {
    my ($self, $slug) = @_;
    $self->posts->find_one({slug => $slug});
}

sub create {
    my ($self, $title, $content, $tags, $public, $created) = @_;
    $public  = 0             unless $public;
    $created = DateTime->now unless $created;
    my $slug = Skryf::Util->slugify($title);
    my $html = Skryf::Util->convert($content);
    $self->posts->insert(
        {   slug    => $slug,
            title   => $title,
            content => $content,
            tags    => $tags,
            public  => $public,
            created => $created->strftime('%Y-%m-%dT%H:%M:%SZ'),
            html    => $html,
        }
    );
}

sub save {
    my ($self, $post) = @_;
    $post->{slug} = Skryf::Util->slugify($post->{title});
    $post->{html} = Skryf::Util->convert($post->{content});
    my $lt = DateTime->now;
    $post->{modified} = $lt->strftime('%Y-%m-%dT%H:%M:%SZ');
    $self->posts->save($post);
}

sub remove {
    my ($self, $slug) = @_;
    $self->posts->remove({slug => $slug});
}

sub by_cat {
    my ($self, $category) = @_;
    my $_filtered = [];
    foreach (@{$self->all}) {
        if ((my $found = $_->{tags}) =~ /$category/) {
            push @{$_filtered}, $_;
        }
    }
    return $_filtered;
}

1;
__END__

=head1 NAME

Skryf::Plugin::Blog:::Model - Skryf Blog Model

=head1 DESCRIPTION

Post model

=head1 METHODS

=head2 B<posts>

Posts collection

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
