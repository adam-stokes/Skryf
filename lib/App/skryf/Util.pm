use strict;
use warnings;
package App::skryf::Util;

use Text::Markdown 'markdown';

sub parse_content {
    my ($contents) = @_;
    markdown($contents, {tab_width => 2});
}

1;
