# Deployment

Few steps to get your environment setup and able to run Skryf.

```
$ curl -L http://install.perlbrew.pl | bash
$ perlbrew install perl-5.20.0
$ cpanm App::skryf
$ skryf setup
$ skryf daemon                         # development
$ skryf                                # production
```
