package App::skryf::Command::newpage;

use strictures 1;
use v5.16;
use FindBin '$Bin';
use Mojo::Base 'Mojolicious::Command';
use Path::Tiny;
use DateTime;
use App::skryf::Util;

# VERSION

has description => "Create a new static page.\n";
has usage => <<"EOF";
Usage: $0 newpage page-name

page-name Should be in the 'a-z 0-9 _ -' set.

EOF

has datetime => sub {
    my $self = shift;
    DateTime->now->set_time_zone($self->app->config->{skryfcfg}->{tz});
};

sub run {
    my ($self, $page) = @_;
    die $self->usage unless $page;

    unless ($page =~ /^[A-Za-z0-9_-]+$/) {
        die "Invalid post name '$page'\n",
          "Page names should be in the 'a-z 0-9 _ -' set";
    }

    my $staticdir = $self->app->config->{skryfcfg}->{static_directory};
    die "No static_directory configured\n" unless $staticdir;
    $staticdir = path(App::skryf::Util->sformat($staticdir, bindir => $Bin));
    my $pendingdir = $staticdir->child('pending');
    $pendingdir->mkpath;

    my $file = $pendingdir->child($page . ".markdown");
    die "Page exists at $file, maybe you wanted 'repost'?\n"
      if $file->exists;

    my $dest =
      $staticdir->child($page . ".markdown");
    die "Page already published at $dest\n" if $dest->exists;

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
        say "\nMove skipped; use 'repost $page' to edit";
    }
}

1;
