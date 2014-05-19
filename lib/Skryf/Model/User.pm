package Skryf::Model::User;

# ABSTRACT: Skryf user model

use DateTime;

use Moo;
use namespace::clean;

has created => (
    is      => 'rw',
    default => sub { my $self = shift; DateTime->now }
);

1;

__END__

=head1 DESCRIPTION

User model

=cut
