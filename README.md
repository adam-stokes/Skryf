# NAME

App-skryf - i kno rite. another perl blogging engine.

# DESCRIPTION

Another blog engine utilizing Mojolicious, Markdown, Hypnotoad, Rex, and Ubic for
a more streamlined deployable approach.

# PREREQS

I like [http://perlbrew.pl](http://perlbrew.pl), but, whatever you're comfortable with. I won't judge.

# INSTALLATION (BLEEDING EDGE)

    $ cpanm git://github.com/battlemidget/App-skryf.git

# SETUP

By default __skryf__ will look in dist\_dir for templates and media. To override that
make sure _~/.skryf.conf_ points to the locations of your templates, posts, and media.
For example, this is a simple directory structure for managing your blog.

    $ mkdir -p ~/blog/{posts,templates,public}

Edit ~/.skryf.conf to reflect those directories in _media\_directory_, _post\_directory_,
and _template\_directory_.

    ## Available vars:
    ##   %bindir%   (path to executable's dir)
    ##   %homedir%  (current $HOME)
    post_directory     => '%homedir%/blog/posts',
    static_directory   => '%homedir%/blog/static',
    template_directory => '%homedir%/blog/templates',
    media_directory    => '%homedir%/blog/public',

You'll want to make sure that files exist that reflect the template configuration options.

    post_template   => 'post',
    index_template  => 'index',
    static_template => 'static',

So __~/blog/templates/{post.html.ep,index.html.ep,about.html.ep}__ and __~/blog/public/style.css__

# NEW POST

    $ skryf newpost a-new-blog-post

# NEW PAGE

    $ skryf newpage an-about-page

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

# DISCLAIMER

Jon Portnoy \[avenj at cobaltirc.org\](http://www.cobaltirc.org) is original author of blagger
in which this code is based heavily off of.

# LICENSE

Licensed under the same terms as Perl.
