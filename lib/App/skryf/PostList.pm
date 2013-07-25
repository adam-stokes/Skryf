use strict;
use warnings;

package App::skryf::PostList;

use Carp 'confess';
use List::Objects::WithUtils;
use Path::Tiny ();

sub as_array {
    my ($self) = @_;
    $self->posts->values;
}

sub by_date {
    my ($self) = @_;
    $self->posts->values->sort_by(sub { $_->date })->reverse;
}

sub by_mtime {
    my ($self) = @_;
    $self->posts->values->sort_by(sub { $_->mtime });
}

sub by_topic {
    my ($self) = @_;
    $self->posts->values->sort_by(sub { $_->topic });
}

sub by_cat {
    my ($self, $category) = @_;
    $self->posts->values->grep(sub { $_->category =~ /$category/i })
      ->sort_by(sub                { $_->date })->reverse;
}

sub get {
    my ($self, $id) = @_;
    my $post = $self->posts->get($id) || return;
    unless ($post->mtime == $post->path->stat->mtime) {
        return $self->_reset_post($id => $post->path);
    }
    $post;
}

1;
