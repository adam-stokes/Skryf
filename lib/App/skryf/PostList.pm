package App::skryf::PostList;

use strictures 1;
use Carp 'confess';
use List::Objects::WithUtils;
use Path::Tiny ();

sub PATH     () { 0 }
sub POSTHASH () { 1 }

sub path  { $_[0]->[PATH]  }
sub posts { $_[0]->[POSTHASH] }

sub from_dir {
  my ($class, $dirpath) = @_;

  my $dir = Path::Tiny::path($dirpath);
  my $self = [
    $dir,     ## PATH
    hash,     ## POSTHASH
  ];
  bless $self, $class;

  # Create initial Posts and add hash() of Posts:
  $self->scan
}

sub scan {
  my ($self) = @_;
  my $dir = $self->path;

  confess "Not a directory: $dir" unless $dir->is_dir;

  my $iter = $dir->iterator;
  SCAN: while (my $child = $iter->()) {
    my $basename = $child->basename;
    my ($maybe_id) = $basename =~ /(.+)\.(?:markdown)$/;
    next SCAN unless $maybe_id;

    if ( $self->posts->exists($maybe_id) ) {
      my $current = $self->posts->get($maybe_id);
      unless ($current->path->basename eq $child->basename) {
        warn "Possible ID conflict for $maybe_id"
          if $current->path->exists;
      }
      next SCAN if $child->stat->mtime == $current->mtime;
    }

    $self->_reset_post( $maybe_id => $child );
  }

  $self
}

sub _reset_post {
  my ($self, $id, $path) = @_;
  my $post = App::skryf::Post->from_file( $path );
  $self->posts->set( $id => $post );
  $post
}

sub as_array {
  my ($self) = @_;
  $self->posts->values
}

sub by_date {
  my ($self) = @_;
  $self->posts->values
    ->sort_by(sub { $_->date })
    ->reverse
}

sub by_mtime {
  my ($self) = @_;
  $self->posts->values
    ->sort_by(sub { $_->mtime })
}

sub by_topic {
  my ($self) = @_;
  $self->posts->values
    ->sort_by(sub { $_->topic })
}

sub by_cat {
    my ($self, $category) = @_;
    $self->posts->values
      ->grep(sub { $_->category =~ /$category/i })
      ->sort_by(sub                { $_->date })
      ->reverse;
}

sub get {
    my ($self, $id) = @_;
    my $post = $self->posts->get($id) || return;
    unless ($post->mtime == $post->path->stat->mtime) {
        return $self->_reset_post($id => $post->path);
    }
    $post;
}

1;
