# NAME

App-skryf - Perl CMS/CMF.

# DESCRIPTION

CMS/CMF platform for Perl.

# PREREQS

[https://github.com/tokuhirom/plenv/](https://github.com/tokuhirom/plenv/).

# INSTALLATION

    $ cpanm App::skryf

# SETUP

    $ skryf setup

## Themes

Themes are installed via cpan, e.g:

    $ cpanm App::skryf::Theme::Booshka

Then specify the theme in your config:

    theme => 'Booshka'

## Plugins

Plugins are installed via cpan, e.g:

    $ cpanm App::skryf::Plugin::Blog

Then specify plugin in your config:

    extra_modules => { 'Blog' => 1 }

A list of supported/tested plugins for Skryf can be found at [https://github.com/skryf](https://github.com/skryf)

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
