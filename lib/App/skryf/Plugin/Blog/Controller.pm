package App::skryf::Plugin::Blog::Controller;

use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::Post;

sub blog_index {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new;
    my $posts = $model->all;
    $self->stash(postlist => $posts);
    $self->render('blog_index');
}

sub blog_detail {
    my $self   = shift;
    my $postid = $self->param('id');
    unless ($postid =~ /^[A-Za-z0-9_-]+$/) {
        $self->render(text => 'Invalid post name!', status => 404);
        return;
    }
    my $model = App::skryf::Model::Post->new;
    my $post = $model->find_one({slug => $postid});
    unless ($post) {
        $self->render(text => 'No post found!', status => $post);
    }

    $self->stash(post => $post);
    $self->render('blog_detail');
}

sub blog_feeds_by_cat {
    my $self     = shift;
    my $category = $self->param('category');
    my $model = App::skryf::Model::Post->new;
    my $_posts   = $model->find({category => $category})->all;
    $self->stash(postlist => $_posts);
    $self->render(template => 'atom', format => 'xml');
}

sub blog_feeds {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new;

    $self->stash(postlist => $model->all);
    $self->render(template => 'atom', format => 'xml');
}

sub admin_blog_index {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new;
    $self->stash(postlist => $model->all);
    $self->render('admin/index');
}

sub admin_blog_new {
    my $self   = shift;
    my $method = $self->req->method;
    if ($method eq "POST") {
        my $topic   = $self->param('topic');
        my $content = $self->param('content');
        my $tags    = $self->param('tags');
        my $model   = App::skryf::Model::Post->new;
        $model->new_post($topic, $content, $tags);
        $self->redirect_to('admin/index');
    }
    else {
        $self->render('admin/new');
    }
}

sub admin_blog_edit {
    my $self   = shift;
    my $postid = $self->param('id');
    my $model   = App::skryf::Model::Post->new;
    $self->stash(post => $model->get($postid));
    $self->render('admin/edit');
}

sub admin_blog_update {
    my $self   = shift;
    my $postid  = $self->param('id');
    my $topic   = $self->param('topic');
    my $content = $self->param('content');
    my $tags    = $self->param('tags');
    my $model   = App::skryf::Model::Post->new;
    $model->update_post($topic, $content, $tags);
    $self->flash(message => "Blog " . $self->param('topic') . " updated.");
    $self->redirect_to($self->url_for('admin_blog_edit', {id => $postid}));
}

sub admin_blog_delete {
    my $self   = shift;
    my $postid = $self->param('id');
    my $model = App::skryf::Model::Post->new;
    if ($model->delete_post($postid)) {
        $self->flash(message => 'Removed.');
    }
    else {
        $self->flash(message => 'Failed to remove post.');
    }
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
