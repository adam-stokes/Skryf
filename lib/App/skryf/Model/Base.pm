package App::skryf::Model::Base;

use Mojo::Base -base;
use Mango;
use Method::Signatures;

has mpath => 'mongodb://localhost:27017/';
has dbname => $ENV{TEST_ONLINE} || 'skryf';

method mgo {
    Mango->new($self->mpath.$self->dbname);
}

1;
__END__

=head1 NAME

App::skryf::Model::Base - Base Model Skryf

=head1 DESCRIPTION

Base model and is usually inherited by other models specific to the storage
type.

=head1 ATTRIBUTES

=head2 B<mpath>

MongoDB connection URI.

=head2 B<dbname>

MongoDB name.

=head1 METHODS

=head2 B<mgo>

The connection method for all inherited model types.

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
