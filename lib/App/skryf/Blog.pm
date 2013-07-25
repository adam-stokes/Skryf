package App::skryf::Blog;
use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::Post;

sub index {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new;

    $self->stash(postlist => $model->all);
    my $tmpl = $self->cfg->{index_template} || 'index';
    $self->render($tmpl);
}

sub feeds_by_cat {
    my $self     = shift;
    my $category = $self->param('category');
    my $_posts   = $self->db->find({category => $category})->all;
    $self->stash(postlist => $_posts);
    $self->render(template => 'atom', format => 'xml');
}

sub feeds {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new;

    $self->stash(postlist => $model->all);
    $self->render(template => 'atom', format => 'xml');
}

sub static_page {
    my $self = shift;
    my $model = App::skryf::Model::Post->new(slug => $self->param('slug'));
    $model->slug($self->param('slug'));

    my $_post = $model->one;
    unless ($_post->ret eq 0) {
        $self->render(text => 'No page found!', status => $_post->ret);
    }
    $self->stash(post => $_post);
    my $tmpl = $self->cfg->{static_template} || 'static';
    $self->render($tmpl);
}

sub post_page {
    my $self = shift;
    my $model = App::skryf::Model::Post->new(slug => $self->param('slug'));
    unless ($model->slug =~ /^[A-Za-z0-9_-]+$/) {
        $self->render(text => 'Invalid post name!', status => 404);
        return;
    }
    my $_post = $model->one;
    unless ($_post->ret eq 0) {
        $self->render(text => 'No post found!', status => $_post->ret);
    }
    $self->stash(post => $_post);

    my $tmpl = $self->cfg->{post_template} || 'post';
    $self->render($tmpl);
}

1;
