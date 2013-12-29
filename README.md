# NAME

App-skryf - Perl CMS/CMF.

# DESCRIPTION

Another CMS platform which utilizes Mojolicious, Markdown, hypnotoad, Rex, Ubic,
and Mongo.

# PREREQS

[http://perlbrew.pl](http://perlbrew.pl) or [https://github.com/tokuhirom/plenv/](https://github.com/tokuhirom/plenv/).

# INSTALLATION (BLEEDING EDGE)

    $ cpanm git://github.com/battlemidget/App-skryf.git

# SETUP

    $ skryf setup

By default __skryf__ will look in dist\_dir for templates and media. To override that
make sure _~/.skryf.conf_ points to the locations of your templates and media.
For example: 

    $ mkdir -p ~/blog/{templates,public}

Edit ~/.skryf.conf to reflect those directories in _template\_directory_ and 
_media\_directory_.

    template_directory => '~/blog/templates',
    media_directory    => '~/blog/public',

So __~/blog/templates/blog/detail.html.ep__ and __~/blog/public/style.css__

# RUN (Development)

    $ skryf daemon

# RUN (Production)

I use Ubic to manage the process

     use Ubic::Service::SimpleDaemon;
     my $service = Ubic::Service::SimpleDaemon->new(
      bin => "hypnotoad -f `which skryf`",
      cwd => "/home/username",
      stdout => "/tmp/blog.log",
      stderr => "/tmp/blog.err.log",
      ubic_log => "/tmp/blog.ubic.log",
      user => "username"
     );

# AUTHOR

Adam Stokes <adamjs@cpan.org>

# COPYRIGHT

Copyright 2013- Adam Stokes

# LICENSE

Licensed under the same terms as Perl.
