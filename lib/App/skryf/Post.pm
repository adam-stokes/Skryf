use strict;
use warnings;

package App::skryf::Post;

use Mojo::Base -base;

use Carp 'confess';
use List::Objects::WithUtils;
use Path::Tiny ();
use Text::Markdown 'markdown';

has [qw(id html mtime topic date category contents)] => '';

sub rendercontent {
    my ($contents) = @_;
    markdown(join('', @$contents), {tab_width => 2});
}

1;
