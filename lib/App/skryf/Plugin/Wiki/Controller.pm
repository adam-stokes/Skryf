package App::skryf::Plugin::Wiki::Controller;

use Mojo::Base 'Mojolicious::Controller';
use Method::Signatures;
use App::skryf::Model::Page;
use String::Util 'trim';

method wiki_index {
    my $model = App::skryf::Model::Page->new;
    my $pages = $model->all;
    $self->stash(pages => $pages);
    $self->render('wiki/index');
}

method wiki_detail {
    my $slug  = $self->param('slug');
    my $model = App::skryf::Model::Page->new;
    my $page  = $model->get($slug);
    unless ($page) {
        $self->render(text => 'No page found', status => 404);
    }
    $self->stash(page => $page);
    $self->render('wiki/detail');
}

method admin_wiki_new {
    my $method = $self->req->method;
    if ($method eq 'POST') {
        my $topic   = $self->param('topic');
        my $content = $self->param('content');
        my $model   = App::skryf::Model::Page->new;
        $model->create($topic, $content);
        $self->redirect_to('wiki_index');
    }
    else {
        $self->render('wiki/new');
    }
}

method admin_wiki_edit {
    my $slug  = $self->param('slug');
    my $model = App::skryf::Model::Page->new;
    $self->stash(page => $model->get($slug));
    $self->render('wiki/edit');
}

method admin_wiki_update {
    my $slug  = $self->param('slug');
    my $model = App::skryf::Model::Page->new;
    my $page  = $model->get($slug);
    $page->{topic}   = $self->param('topic');
    $page->{content} = trim($self->param('content'));
    $model->save($page);
    $self->flash(message => "Saved: " . $self->param('topic'));
    $self->redirect_to(
        $self->url_for('wiki_detail', {slug => $page->{slug}}));
}

method admin_wiki_delete {
    my $slug  = $self->param('slug');
    my $model = App::skryf::Model::Page->new;
    if ($model->remove($slug)) {
        $self->flash(message => $slug . ' removed');
    }
    $self->redirect_to('wiki_index');
}

1;
