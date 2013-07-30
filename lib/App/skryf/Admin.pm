package App::skryf::Admin;
use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::Post;

sub index {
    my $self = shift;
    my $model = App::skryf::Model::Post->new(db => $self->db);

    $self->stash(postlist => $model->all);
    $self->render(template => 'admin/index');
}

sub new_post {
    my $self   = shift;
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

sub edit_post {
    my $self = shift;
    my $model = $self->db->find_one({slug => $self->param('slug')});
    if ($model) {
        $self->stash(post => $model);
        $self->render('admin/edit');
    }
    else {
        $self->flash(message => 'Could not find post to update.');
        $self->redirect_to('admin_index');
    }
}

sub delete_post {
    my $self  = shift;
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

1;
