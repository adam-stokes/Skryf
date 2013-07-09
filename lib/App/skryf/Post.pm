package App::skryf::Post;

use strictures 1;
use Carp 'confess';
use List::Objects::WithUtils;
use Path::Tiny ();
use Text::Markdown 'markdown';

sub PATH ()     {0}
sub TOPIC ()    {1}
sub DATE ()     {2}
sub CATEGORY () {3}
sub POSTID ()   {4}
sub CONTENTS () {5}
sub HTML ()     {6}
sub MTIME ()    {7}

sub html     { $_[0]->[HTML] }
sub contents { $_[0]->[CONTENTS] }
sub path     { $_[0]->[PATH] }
sub topic    { $_[0]->[TOPIC] }
sub date     { $_[0]->[DATE] }
sub category { $_[0]->[CATEGORY] }
sub id       { $_[0]->[POSTID] }
sub mtime    { $_[0]->[MTIME] }

sub last_edit { 
  my ($self) = @_;
  POSIX::strftime( '%Y-%m-%d %H:%M:%S', localtime($self->mtime) )
}

sub _parsepost {
    my ($path) = @_;
    confess "Expected a Path::Tiny object"
      unless ref $path and $path->can('lines_utf8');

    my $full = array($path->lines_utf8);

    my $header   = $full->items_before(sub { $_ eq "\n" });
    my $contents = $full->items_after(sub  { $_ eq "\n" });

    my ($topicline, $dateline, $categoryline);
    for my $line ($header->all) {
        if (index($line, 'Topic: ') == 0) {
            $topicline = $line;
            next;
        }
        if (index($line, 'Date: ') == 0) {
            $dateline = $line;
            next;
        }
        if (index($line, 'Category: ') == 0) {
            $categoryline = $line;
            next;
        }
    }

    warn "Malformed post at " . $path->absolute
      unless $topicline
      and $dateline
      and $categoryline;
    warn "Empty post at " . $path->absolute
      unless $contents->count;

    my $topic = substr($topicline, 7);
    warn "Post at @{[$path->absolute]} is missing a Topic:\n"
      unless $topic;

    my $date = substr($dateline, 6, -1);
    warn "Post at @{[$path->absolute]} is missing a Date:\n"
      unless $date;

    my $category = substr($categoryline, 10);
    warn "Plag post at @{[$path->absolute]} is missage a Category:\n"
      unless $category;

    hash(
        topic    => $topic,
        date     => $date,
        category => $category,
        contents => $contents,
    );
}

sub _renderpost {
  my ($contents) = @_;
  markdown( join('', @$contents), { tab_width => 2 } )
}

sub from_file {
    my ($class, $filepath) = @_;
    confess "Expected a path" unless defined $filepath;

    my $self = [];

    my $file = Path::Tiny::path($filepath);
    confess "Nonexistant post path ($filepath) " . $file->absolute
      unless $file->exists;

    my $item     = _parsepost($file);
    my $topic    = $item->get('topic');
    my $date     = $item->get('date');
    my $category = $item->get('category');

    my $contents = $item->get('contents');
    my $html     = _renderpost($contents);

    my ($postid) = $file->basename =~ /(.+)\.(?:markdown)$/;

    my $mtime = $file->stat->mtime;

    bless [
        $file,        ## PATH    (Path::Tiny obj, stringifies)
        $topic,       ## TOPIC
        $date,        ## DATE
        $category,    ## CATEGORY
        $postid,      ## POSTID
        $contents,    ## CONTENTS
        $html,        ## HTML
        $mtime,       ## MTIME
    ], $class;
}
1;
