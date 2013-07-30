use strict;
use warnings;
package App::skryf::Admin;
use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::Post;
use Method::Signatures;
use Data::Printer;

method index {
    my $model = App::skryf::Model::Post->new(db => $self->db);

    $self->stash(postlist => $model->all);
    $self->render(template => 'admin/index');
}

method new_post {
    my $method = $self->req->method;
    if ($method eq "POST") {
        my $topic   = $self->param('topic');
        my $content = $self->param('content');
        my $tags    = $self->param('tags');
        my $model   = App::skryf::Model::Post->new(db => $self->db);
        $model->new_post($topic, $content, $tags);
        $self->redirect_to('admin_index');
    }
    else {
        $self->render('admin/new');
    }
}

method edit_post {
    my $method  = $self->req->method;
    my $model   = App::skryf::Model::Post->new(db => $self->db);
    $self->stash(post => $model->get($self->param('slug')));
    $self->render('admin/edit');
}

method delete_post {
    my $slug  = $self->param('slug');
    my $model = App::skryf::Model::Post->new(db => $self->db);
    if ($model->delete_post($slug)) {
        $self->flash(message => 'Removed.');
    }
    else {
        $self->flash(message => 'Failed to remove post.');
    }
    $self->redirect_to('admin_index');
}

method update_post {
    my $topic   = $self->param('topic');
    my $content = $self->param('content');
    my $tags    = $self->param('tags');
    my $model   = App::skryf::Model::Post->new(db => $self->db);
    $model->update_post($topic, $content, $tags);
    $self->flash(message => "Page titled: " . $topic . " updated.");
    $self->redirect_to('admin_index');
}

1;
