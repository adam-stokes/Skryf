package App::skryf::Plugin::Blog::Controller;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dump qw[pp];

sub blog_index {
    my $self  = shift;
    my $rs    = $self->blogconf->{dbrs};
    my $posts = $rs->search({}, {limit => 15})
      ->array_of_hash_rows(['id', 'title', 'body', 'created']);

    $self->stash(postlist => $posts);
    $self->render('blog_index');
}

sub blog_archive {
    my $self  = shift;
    my $rs    = $self->blogconf->{dbrs};
    my $posts = $rs->array_of_hash_rows(['id', 'title', 'body', 'created']);

    $self->stash(postlist => $posts);
    $self->render('blog_archive');
}

sub blog_detail {
    my $self   = shift;
    my $postid = $self->param('id');

    my $rs = $self->blogconf->{dbrs};
    my $post = $rs->search({id => $postid})
      ->hash_row(['id', 'title', 'body', 'created']);

    $self->stash(post => $post);
    $self->render('blog_detail');
}

sub admin_blog_index {
    my $self  = shift;
    my $rs    = $self->blogconf->{dbrs};
    my $posts = $rs->search({}, {limit => 15})
      ->array_of_hash_rows(['id', 'title', 'body', 'created']);

    $self->stash(postlist => $posts);
    $self->render('admin_blog_index');
}

sub admin_blog_new {
    my $self   = shift;
    my $method = $self->req->method;
    if ($method eq "POST") {
        my $rs = $self->blogconf->{dbrs};
        $rs->insert(
            {   title => $self->param('title'),
                body  => $self->param('body'),
            }
        );

        $self->flash(
            message => "New blog post " . $self->param('title') . " added.");
        $self->redirect_to($self->url_for('adminblog'));
    }
    else {
        $self->render('admin_blog_new');
    }
}

sub admin_blog_edit {
    my $self   = shift;
    my $postid = $self->param('id');

    my $rs = $self->blogconf->{dbrs};
    my $post = $rs->search({id => $postid})
      ->hash_row(['id', 'title', 'body', 'created']);

    $self->stash(post => $post);

    $self->render('admin_blog_edit');
}

sub admin_blog_update {
    my $self   = shift;
    my $postid = $self->param('id');

    my $rs = $self->blogconf->{dbrs};
    my $post =
      $rs->search({id => $postid})
      ->update(
        {title => $self->param('title'), body => $self->param('body')});
    $self->flash(message => "Blog " . $self->param('title') . " updated.");
    $self->redirect_to($self->url_for('adminblogeditid', {id => $postid}));
}

sub admin_blog_delete {
    my $self   = shift;
    my $postid = $self->param('id');

    my $rs = $self->blogconf->{dbrs};
    my $post =
      $rs->search({id => $postid})
      ->delete();
    $self->flash(message => "Blog ".$postid." deleted.");
    $self->redirect_to($self->blogconf->{adminPathPrefix} . "/blog/");
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::Blog::Controller - blog plugin controller

=head1 DESCRIPTION

Simple controller class for handling listing, viewing, and administering
blog posts.

=head1 CONTROLLERS

=head2 B<blog_index>

=head2 B<blog_archive>

=head2 B<blog_detail>

=head2 B<admin_blog_new>

=head2 B<admin_blog_edit>

=head2 B<admin_blog_update>

=head2 B<admin_blog_delete>

=cut
