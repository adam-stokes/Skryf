package App::skryf::Model::Base;

use Mojo::Base -base;
use Mango;

has dsn     => $ENV{TEST_ONLINE} || 'mongodb://localhost:27017/skryf';

sub mgo {
    my ($self) = @_;
    Mango->new($self->dsn);
}

1;
