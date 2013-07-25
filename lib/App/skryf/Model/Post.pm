use strict;
use warnings;

package App::skryf::Model::Post;

use Mojo::Base -base;
use List::Objects::WithUtils;
use App::skryf::Util;

has [qw(slug html mtime topic date category contents)] => '';
has ret   => 0;
has orig  => hash();
has posts => array();
has html => sub {
    my ($self) = @_;
    App::skryf::Util->parse_content($self->contents);
};

sub _merge {
    my ($self) = @_;
    $self->category($self->orig->{category});
    $self->contents($self->orig->{contents});
    $self->mtime($self->orig->{mtime});
    $self->topic($self->orig->{topic});
    $self->date($self->orig->{date});
}

sub one {
    my ($self) = @_;
    $self->orig($self->db->find_one({slug => $self->slug}));
    if ($self->orig) {
        $self->_merge;
    }
    else {
        $self->ret(404);
    }
}

sub all {
    my ($self) = @_;
    my $_posts = $self->db->all;
    foreach (@{$_posts}) {
        $self->orig($_)->_merge;
        push @$self->posts,
          { $self->category, $self->contents, $self->mtime,
            $self->topic,    $self->date,     $self->ret,
          };
    }
}

sub save {
    my ($self) = @_;
    if ($self->ret eq 0) {
        $self->db->update({slug => $self->slug}, $self->orig);
    }
    else {
        $self->db->insert($self->orig);
    }
}

1;
