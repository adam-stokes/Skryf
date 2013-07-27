package App::skryf::Blog;
use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::Post;
use App::skryf::Model::User;
use Data::Dumper;

sub index {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new(db => $self->db);
    my $posts = $model->all;
    $self->stash(postlist => $posts);
    my $tmpl = $self->cfg->{index_template};
    $self->render($tmpl);
}

sub feeds_by_cat {
    my $self     = shift;
    my $category = $self->param('category');
    my $_posts   = $self->mgo->find({category => $category})->all;
    $self->stash(postlist => $_posts);
    $self->render(template => 'atom', format => 'xml');
}

sub feeds {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new(db => $self->db);

    $self->stash(postlist => $model->all);
    $self->render(template => 'atom', format => 'xml');
}

sub static_page {
    my $self = shift;
    my $model = App::skryf::Model::Post->new(db => $self->db, slug => $self->param('slug'));
    $model->slug($self->param('slug'));

    my $_post = $model->one;
    unless ($_post) {
        $self->render(text => 'No page found!', status => 404);
    }
    $self->stash(post => $_post);
    my $tmpl = $self->cfg->{static_template};
    $self->render($tmpl);
}

sub post_page {
    my $self = shift;
    my $slug = $self->param('slug');
    unless ($slug =~ /^[A-Za-z0-9_-]+$/) {
        $self->render(text => 'Invalid post name!', status => 404);
        return;
    }
    my $_post = $self->db->find_one({slug => $slug});
    unless ($_post) {
        $self->render(text => 'No post found!', status => $_post);
    }
    $self->stash(post => $_post);

    my $tmpl = $self->cfg->{post_template};
    $self->render($tmpl);
}

1;
