package Skryf::Util;

use Mojo::Base -base;

use Mojo::JSON;
use Text::MultiMarkdown 'markdown';
use String::Dirify 'dirify';
use String::Util 'trim';
use XML::Atom::SimpleFeed;
use Encode;
use DateTime::Format::RFC3339;

our $VERSION = '1.0.0';

sub convert {
    my ($self, $content, $use_wikilinks) = @_;
    markdown(
        $content,
        {   empty_element_suffix => '>',
            tab_width            => 2,
            use_wikilinks        => $use_wikilinks,
        }
    );
}

sub slugify {
    my ($self, $topic, $auto) = @_;
    dirify($topic, '-');
}

sub feed {
    my ($self, $config, $posts) = @_;
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
        my $f  = DateTime::Format::RFC3339->new();
        my $dt = $f->parse_datetime($post->{created});
        $feed->add_entry(
            title   => $post->{topic},
            link    => $config->{site} . '/post/' . $post->{slug},
            id      => $config->{site} . '/post/' . $post->{slug},
            content => $post->{html},
            updated => $f->format_datetime($dt),
        );
    }
    return $feed;
}

sub json {
    my $self = shift;
    return Mojo::JSON->new;
}

1;
