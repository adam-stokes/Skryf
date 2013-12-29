# NAME

App-skryf - Perl CMS/CMF.

# DESCRIPTION

CMS/CMF platform for Perl.

# PREREQS

[https://github.com/tokuhirom/plenv/](https://github.com/tokuhirom/plenv/).

# INSTALLATION (BLEEDING EDGE)

    $ cpanm https://github.com/skryf/App-skryf.git

# SETUP

    $ skryf setup

## Themes

Themes are installed via cpan, e.g:

    $ cpanm https://github.com/skryf/App-skryf-Theme-Booshka.git

Then specify the theme in your config:

    theme => 'Booshka'

## Plugins

Plugins are installed via cpan, e.g:

    $ cpanm https://github.com/skryf/App-skryf-Plugin-Blog.git

Then specify plugin in your config:

    extra_modules => { 'Blog' => 1 }

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

Copyright 2013-2014 Adam Stokes

# LICENSE

Licensed under the same terms as Perl.
