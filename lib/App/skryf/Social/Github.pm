package App::skryf::Social::Github;

# VERSION

use strictures 1;
use Pithub;

sub repos {
  my ($self, $username) = @_;
  my $repos = Pithub::Repos->new;

  return $repos->list(user => $username);;
}

1;

__END__
