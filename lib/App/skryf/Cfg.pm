package App::skryf::Cfg;

use Carp 'confess';

sub TITLE ()     {0}
sub AUTHOR ()    {1}
sub DESC ()      {2}
sub CONTACT ()   {3}
sub SITE ()      {4}
sub DISQUS ()    {5}
sub GITHUB ()    {6}
sub CODERWALL () {7}

sub author      { $_[0]->[AUTHOR] }
sub contact     { $_[0]->[CONTACT] }
sub title       { $_[0]->[TITLE] }
sub description { $_[0]->[DESC] }
sub site        { $_[0]->[SITE] }
sub disqus      { $_[0]->[DISQUS] }
sub github      { $_[0]->[GITHUB] }
sub coderwall   { $_[0]->[CODERWALL] }

sub new {
    my ($class, %params) = @_;
    bless [
        ($params{title}       || 'my underconfigured blag!'),    # TITLE
        ($params{author}      || 'No One'),                      # AUTHOR
        ($params{description} || 'Is this the internet?'),       # DESC
        ($params{contact}     || '/dev/null'),                   # CONTACT
        ($params{site}        || 'http://astokes.org'),          # SITE
        ($params{disqus}      || 'momo'),                        # DISQUS
    ], $class;
}

1;
