# NAME

App-skryf - i kno rite. another perl cms.

# DESCRIPTION

Another CMS platform which utilizes Mojolicious, Markdown, hypnotoad, Rex, Ubic,
and Mongo.

# PREREQS

I like [http://perlbrew.pl](http://perlbrew.pl), but, whatever you're comfortable with. I won't judge.

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

# DEPLOY

    $ export BLOGUSER=username
    $ export BLOGSERVER=example.com

    If perlbrew is installed Rex will autoload that environment to use remotely.
    Otherwise more tinkering is required to handle the perl environment remotely.
    $ rexify --use=Rex::Lang::Perl::Perlbrew
    $ rex deploy

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

<img src="https://travis-ci.org/battlemidget/App-skryf.png?branch=master" />
