package App::skryf::Model::Base;

use Mojo::Base -base;
use Mango;

sub blog {
    my $self = shift;
    $self->db->collection('blog');
}

sub users {
    my $self = shift;
    $self->db->collection('user');
}

sub db {
    my ($self, $dsn) = @_;
    my $db = Mango->new($dsn);
    $db->default_db('skryf');
    return $self;
}
1;
