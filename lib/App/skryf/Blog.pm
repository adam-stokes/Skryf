package App::skryf::Blog;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;
  my $_posts = $self->db->all;

  $self->stash(postlist => $_posts);

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
  my $self   = shift;
  my $_posts = $self->db->all;

  $self->stash(postlist => $_posts);
  $self->render(template => 'atom', format => 'xml');
}

sub static_page {
  my $self  = shift;
  my $slug  = $self->param('slug');
  my $tmpl  = $self->cfg->{static_template} || 'static';
  my $_post = $self->db->find_one({slug => $slug});
  $self->stash(post => $_post);
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
                $self->render(text => 'No post found!', status => 404);
            }
            $self->stash(post => $_post);

            my $tmpl = $self->skryfcfg->{post_template} || 'post';
            $self->render($tmpl);

}

1;
