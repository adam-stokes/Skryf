package App::skryf::Plugin::Wiki::Controller;

use Mojo::Base 'Mojolicious::Controller';
use Method::Signatures;
use App::skryf::Model::Page;

method wiki_index {
  $self->render('wiki/index');
}

method wiki_detail {
  my $slug = $self->param('slug');
  my $model = App::skryf::Model::Page->new;
  my $page = $model->get($slug);
  unless ($page) {
    $self->render(text => 'No page found', status => 404);
  }
  $self->stash(page => $page);
  $self->render('wiki/detail');
}

1;
