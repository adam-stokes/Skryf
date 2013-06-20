package Mojolicious::Command::newpost;

use strictures 1;
use v5.16;
use FindBin '$Bin';
use Mojo::Base 'Mojolicious::Command';
use Path::Tiny;
use DateTime;
use App::skryf::Util;
use Data::Dump qw[pp];
# VERSION

has description => "Create blog post.\n";
has usage => <<"EOF";
Usage: $0 newpost new-blog-entry

new-blog-entry Should be in the 'a-z 0-9 _ -' set.

EOF

has datetime => sub {
    my $self = shift;
    DateTime->now->set_time_zone($self->app->config->{skryfcfg}->{tz});
};

sub run {
    my ($self, $post) = @_;
    die $self->usage unless $post;

    unless ($post =~ /^[A-Za-z0-9_-]+$/) {
        die "Invalid post name '$post'\n",
          "Post names should be in the 'a-z 0-9 _ -' set";
    }

    my $postdir = $self->app->config->{skryfcfg}->{post_directory};
    die "No post_directory configured\n" unless $postdir;
    $postdir = path(App::skryf::Util->sformat($postdir, bindir => $Bin));
    my $pendingdir = $postdir->child('pending');
    $pendingdir->mkpath;

    my $file = $pendingdir->child($post . ".markdown");
    die "Post exists at $file, maybe you wanted 'repost'?\n"
      if $file->exists;

    my $dest =
      $postdir->child(
        $self->datetime->strftime("%Y-%m-%d") . '-' . $post . ".markdown");
    die "Post already published at $dest\n" if $dest->exists;

    print "Topic: ";
    my $topic = <STDIN>;
    chomp $topic;
    my $date = $self->datetime->datetime() . 'Z';
    print "Categories: ";
    my $category = <STDIN>;
    chomp $category;

    my @tmp = (
        "Topic: $topic\n",
        "Date: $date\n",
        "Category: $category\n\n",
        "## Gimme some header\n\n",
        "Hi, put some Markdown here.\n",
    );

    $file->spew_utf8(@tmp);

    system($ENV{EDITOR}, "$file");

    print "Publish now? [Y/n] ";
    my $ans = <STDIN>;
    chomp $ans;
    $ans = lc($ans || 'y');
    if ($ans eq 'y') {
        say "\nMoving to " . $dest->absolute;
        $file->move($dest->absolute);
    }
    else {
        say "\nMove skipped; use 'repost $post' to edit";
    }
}

1;
