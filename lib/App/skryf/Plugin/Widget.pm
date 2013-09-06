package App::skryf::Plugin::Widget;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';
use Mojo::ByteStream 'b';

sub register {
    my ($plugin, $app) = @_;

    $app->helper(
        widget_aboutme => sub {
            my $self     = shift;
            my $nickname = shift;
            b(  sprintf('<script src="//about.me/embed/%s"></script>',
                    $nickname)
            );
        }
    );

    return $plugin;
}

1;
__END__

=head1 NAME

App::skryf::Plugin::Widget - Widget helpers

=head1 SYNOPSIS

  <%= widget_aboutme 'adam.stokes' %>

=head1 DESCRIPTION

L<App::skryf::Plugin::Widget> is a L<Mojolicious> plugin. Includes helpers for some simple 
includes that doesn't warrant a full blow plugin.

=head1 HELPERS

=head2 C<widget_aboutme>

Takes B<nickname> as argument and embeds the http://about.me widget.

=head1 METHODS

L<Mojolicious::Plugin::Blog> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
