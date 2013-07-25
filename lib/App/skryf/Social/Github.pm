use strict;
use warnings;
package App::skryf::Social::Github;

use Pithub;

sub repos {
    my ($self, $username) = @_;
    my $repos = Pithub::Repos->new;

    return $repos->list(user => $username);
}

1;

__END__
