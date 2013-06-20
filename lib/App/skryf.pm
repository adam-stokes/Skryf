use strictures 1;
package App::skryf;

# VERSION

1;

__END__

=head1 NAME

App-skryf - perl blogger

=head1 PREREQS

I like L<http://perlbrew.pl>, but, whatever you're comfortable with. I won't judge.

=head1 INSTALLATION

    $ git clone git://github.com/battlemidget/App-skryf.git
    $ cpanm --installdeps .

=head1 DEPLOY

    $ export BLOGUSER=username
    $ export BLOGSERVER=example.com

    If perlbrew is installed Rex will autoload that environment to use remotely.
    Otherwise more tinkering is required to handle the perl environment remotely.
    $ rex deploy

=head1 RUN (Development)

    $ morbo `which skryf`

=head1 RUN (Production)

I use Ubic to manage the process

     use Ubic::Service::SimpleDaemon;
     my $service = Ubic::Service::SimpleDaemon->new(
      bin => "starman -p 9001 perl5/perlbrew/perls/perl-5.16.3/bin/skryf -R",
      cwd => "/home/username",
      stdout => "/tmp/blog.log",
      stderr => "/tmp/blog.err.log",
      ubic_log => "/tmp/blog.ubic.log",
      user => "username"
     );

=head1 AUTHOR

Adam Stokes <adamjs@cpan.org>

=head1 DISCLAIMER

Jon Portnoy [avenj at cobaltirc.org](http://www.cobaltirc.org) is original author of blagger
in which this code is based heavily off of.

=head1 LICENSE

Licensed under the same terms as Perl.

=cut
