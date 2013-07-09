package App::skryf::Cfg;

use Carp 'confess';

sub TITLE ()    {0}
sub AUTHOR ()   {1}
sub DESC ()     {2}
sub CONTACT ()  {3}
sub GRAVATAR () {4}
sub SITE ()     {5}

sub author      { $_[0]->[AUTHOR] }
sub contact     { $_[0]->[CONTACT] }
sub title       { $_[0]->[TITLE] }
sub description { $_[0]->[DESC] }
sub gravatar    { $_[0]->[GRAVATAR] }
sub site        { $_[0]->[SITE] }

sub new {
    my ($class, %params) = @_;
    bless [
        ($params{title}       || 'my underconfigured blag!'),    # TITLE
        ($params{author}      || 'No One'),                      # AUTHOR
        ($params{description} || 'Is this the internet?'),       # DESC
        ($params{contact}     || '/dev/null'),                   # CONTACT
        ($params{gravatar}    || ''),                            # GRAVATAR
        ($params{site}        || 'http://astokes.org'),          # GRAVATAR
    ], $class;
}

1;
