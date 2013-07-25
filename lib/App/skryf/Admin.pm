package App::skryf::Admin;
use Mojo::Base 'Mojolicious::Controller';
use App::skryf::Model::Post;

sub index {
    my $self  = shift;
    my $model = App::skryf::Model::Post->new;

    $self->stash(postlist => $model->all);
    $self->render(template => 'admin_index');
}

1;
