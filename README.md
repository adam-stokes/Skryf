# DESCRIPTION

easy does it web application development.

# PREREQS

Perl 5.18+ and Mongo 2.6+.

# INSTALL

    $ cpanm git@github.com:skryf/Skryf.git
    $ skryf new [NAME]
    $ cd [NAME]
    $ morbo app.pl

# METHODS

[Skryf](https://metacpan.org/pod/Skryf) inherits all methods from
[Mojolicious](https://metacpan.org/pod/Mojolicious) and overloads the following:

## startup

This is your main hook into the application, it will be called at
application startup. Meant to be overloaded in a subclass.

# AUTHOR

Adam Stokes <adamjs@cpan.org>
