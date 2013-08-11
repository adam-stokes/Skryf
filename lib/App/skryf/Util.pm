package App::skryf::Util;

use strict;
use warnings;

use Method::Signatures;
use Text::MultiMarkdown 'markdown';
use String::Dirify 'dirify';
use String::Util 'trim';
use XML::Atom::SimpleFeed;
use Encode;
use DateTime::Format::RFC3339;

method convert ($content, $use_wikilinks=0) {
    markdown(trim($content), {
    empty_element_suffix => '>',
    tab_width => 2,
    use_wikilinks => $use_wikilinks,
  });
}

method slugify ($topic, $auto = 0) {
    dirify($topic, '-');
}

method feed ($config, $posts) {
    my $feed = XML::Atom::SimpleFeed->new(
        title => $config->{title},
        link  => $config->{site},
        link  => {
            rel  => 'self',
            href => $config->{site} . '/post/atom.xml',
        },
        author => $config->{author},
        id     => $config->{site},
    );
    for my $post (@{$posts}) {
        my $f = DateTime::Format::RFC3339->new();
        my $dt = $f->parse_datetime($post->{created});
        $feed->add_entry(
            title   => $post->{topic},
            link    => $config->{site} . '/post/' . $post->{slug},
            id      => $config->{site} . '/post/' . $post->{slug},
            content => decode_utf8($post->{html}),
            updated => $f->format_datetime($dt),
        );
    }
    return $feed;
}

1;
