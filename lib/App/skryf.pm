use strictures 1;
package App::skryf;

# VERSION

1;

__END__

=head1 NAME

App-skryf - perl blogger

=head1 DESCRIPTION

Another blog engine utilizing Mojolicious, Markdown, Starman, Rex, and Ubic for
a more streamlined deployable approach.

=head1 PREREQS

I like L<http://perlbrew.pl>, but, whatever you're comfortable with. I won't judge.

=head1 INSTALLATION (SOURCE)

    $ git clone git://github.com/battlemidget/App-skryf.git
    $ cpanm --installdeps .

=head1 SETUP

By default B<skryf> will look in dist_dir for templates and media. To override that
make sure I<~/.skryf.conf> points to the locations of your templates, posts, and media.
For example, this is a simple directory structure for managing your blog.

    $ mkdir -p ~/blog/{posts,templates,public}

Edit ~/.skryf.conf to reflect those directories in I<media_directory>, I<post_directory>,
and I<template_directory>.

    ## Available vars:
    ##   %bindir%   (path to executable's dir)
    ##   %homedir%  (current $HOME)
    post_directory     => '%homedir%/blog/posts',
    template_directory => '%homedir%/blog/templates',
    media_directory    => '%homedir%/blog/public',

You'll want to make sure that files exist that reflect the template configuration options.

    post_template  => 'post',
    index_template => 'index',
    about_template => 'about',
    css_template   => 'style',

So B<~/blog/templates/{post.html.ep,index.html.ep,about.html.ep}> and B<~/blog/public/style.css>

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
      bin => "starman -p 9001 `which skryf` -R",
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
