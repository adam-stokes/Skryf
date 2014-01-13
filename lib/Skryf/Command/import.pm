package Skryf::Command::import;

use Mojo::Base 'Mojolicious::Command';
use FindBin '$Bin';
use feature qw[say];
use Carp;
use Path::Tiny;
use Skryf::Model::Blog;
use DateTime::Format::RFC3339;

our $VERSION = '0.99_5';

has description => "Import blog posts from another service\n";
has usage       => <<"EOF";

Usage: $0 import [service] [static posts]

[jekyll|octopress|hexo] service is required
  Supported Services:
    - jekyll/octopress

EOF

sub format_date {
    my ($self, $date) = @_;
    my $dt = DateTime::Format::RFC3339->new;
    if ($date !~ /\d+:\d+:\d+Z/) {
        return $dt->parse_datetime($date . 'T00:00:59Z');
    }
    return $dt->parse_datetime($date);
}

sub run {
    my ($self, $service, @args) = @_;
    my $model = Skryf::Model::Blog->new;
    croak($self->usage) unless $service =~ /skryf|jekyll/;

    if ($service eq lc "jekyll" || $service eq lc "octopress") {
        croak('Needs -d [posts] directory defined') unless $args[1];
        my $work_dir = path($args[1]);
        say "Starting import of posts in $args[1] ... Please wait.";
        for ($work_dir->children) {
            my $post      = $_->slurp_utf8;
            my ($topic)   = $post =~ /^Topic:\s+(.*)/;
            my ($date)    = $post =~ /Date:\s+(.*)/;
            my ($tags)    = $post =~ /Category:\s+(.*)/;
            my ($content) = $post =~ /^\n(.*)/ms;
            say "processing $topic";
            $model->create($topic, $content, $tags,
                $self->format_date($date));
        }
        say "Import complete";
    }
    elsif ($service eq lc "hexo") {
        croak "Not implemented.";
    }
    else {
        croak "Unknown service: $service";
    }
}

1;
