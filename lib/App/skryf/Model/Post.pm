use strict;
use warnings;

package App::skryf::Model::Post;

use Mojo::Base -base;
use List::Objects::WithUtils;
use App::skryf::Util;
use Data::Printer;
use Mango;

has [qw(db slug mtime topic date category contents)] => sub {};
has ret   => 0;
has orig  => sub { hash() };
has posts => sub { array() };
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
    my $_posts = $self->db->find();
    foreach ($_posts) {
        p($_);
        $self->orig($_)->_merge;
        $self->posts->push(
            {   $self->category, $self->contents, $self->mtime,
                $self->topic,    $self->date,     $self->ret,
            }
        );
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
