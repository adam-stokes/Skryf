package App::skryf::Util;
use strict;
use warnings;

use Text::Markdown 'markdown';
use String::Dirify 'dirify';

sub convert {
    my ($self, $content) = @_;
    markdown($content, {tab_width => 2});
}

sub slugify {
  my ($self, $topic) = @_;
  dirify($topic, '-');
}

1;
