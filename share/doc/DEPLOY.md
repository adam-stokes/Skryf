# Deployment

Few steps to get your environment setup and able to run Skryf.

```
$ git clone git://github.com/tokuhirom/plenv.git ~/.plenv
$ git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/

$ cat >> ~/.zshrc                      # or .bashrc
# PLENV
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init - --no-rehash)"
ctrl+D

$ plenv install 5.18.2 --as=skryf
$ plenv global skryf
$ cpanm App::skryf
$ skryf setup
$ skryf daemon                         # development
$ skryf                                # production
```
