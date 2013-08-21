package App::skryf::Model::Base;

use Mojo::Base -base;
use Mango;

has dsn     => $ENV{TEST_ONLINE} || 'mongodb://localhost:27017/skryf';

sub mgo {
    my ($self) = @_;
    Mango->new($self->dsn);
}

1;
__END__

=head1 NAME

App::skryf::Model::Base - Base Model Skryf

=head1 DESCRIPTION

Base model and is usually inherited by other models specific to the storage
type.

=head1 METHODS

=head2 B<mgo>

The connection method for all inherited model types.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
