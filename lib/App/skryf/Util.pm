package App::skryf::Util;

use strict;
use warnings;

use Method::Signatures;
use Text::Markdown 'markdown';
use String::Dirify 'dirify';

method convert ($content) {
    markdown($content, {tab_width => 2});
}

method slugify ($topic) {
  dirify($topic, '-');
}

1;
