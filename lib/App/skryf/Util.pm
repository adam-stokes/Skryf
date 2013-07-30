use strict;
use warnings;
package App::skryf::Util;

use Text::Markdown 'markdown';
use String::Dirify 'dirify';
use Data::Printer;

sub convert {
    my ($self, $content) = @_;
    p($content);
    markdown($content, {tab_width => 2});
}

sub slugify {
  my ($self, $topic) = @_;
  dirify($topic, '-');
}

1;
