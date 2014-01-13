#!/usr/bin/env perl
use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin" }

require Mojolicious::Commands;
Mojolicious::Commands->start_app('Skryf');

__END__

=head1 NAME

Skryf - Perl on web.

=head1 DESCRIPTION

Perl on web, easy does it web development.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013-2014 Adam Stokes

=head1 LICENSE

Licensed under the same terms as Perl.

=cut
