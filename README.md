# NAME

Skryf - Perl on web.

# DESCRIPTION

Perl on web platform.

# PREREQS

Perl 5.14 or higher, [App::cpanminus](https://metacpan.org/pod/App::cpanminus) >= 1.7102, and Mongo.

# INSTALL

    $ cpanm git@github.com:skryf/Skryf.git
    $ skryf new [NAME]
    $ cd [NAME]
    $ carton install
    $ carton exec morbo app.pl

# METHODS

[Skryf](https://metacpan.org/pod/Skryf) inherits all methods from
[Mojolicious](https://metacpan.org/pod/Mojolicious) and overloads the following:

## startup

This is your main hook into the application, it will be called at
application startup. Meant to be overloaded in a subclass.

# AUTHOR

Adam Stokes <adamjs@cpan.org>

# COPYRIGHT

Copyright 2013-2014 Adam Stokes

# LICENSE

Licensed under the same terms as Perl.
