package Skryf::Model::Base;

use Mojo::Base -base;
use Mango;

has 'mpath' => 'mongodb://localhost:27017/';

has 'dbname' => sub {
    my $self = shift;
    my $_dbname = $ENV{TEST_ONLINE} || 'skryf';
    return $_dbname;
};

sub mgo {
    my $self = shift;
    return Mango->new($self->mpath . $self->dbname);
}

sub current_db {
    my $self = shift;
    return sprintf("%s%s", $self->mpath, $self->dbname);
}

1;
__END__

=head1 NAME

Skryf::Model::Base - Base Model Skryf

=head1 DESCRIPTION

Base model and is usually inherited by other models specific to the storage
type.

=head1 ATTRIBUTES

=head2 mpath

MongoDB connection URI.

=head2 dbname

MongoDB name.

=head1 METHODS

=head2 mgo

The connection method for all inherited model types.

=head2 current_db

The currently used database.

=head1 AUTHOR

Adam Stokes

=head1 COPYRIGHT

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

=head1 LICENSE

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>.

=cut
