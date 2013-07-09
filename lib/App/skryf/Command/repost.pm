package App::skryf::Command::repost;

use strict;
use warnings;
use v5.16;
use FindBin '$Bin';
use Mojo::Base 'Mojolicious::Command';
use Path::Tiny;
use DateTime;

use App::skryf::Util;

# VERSION

has description => "Edit pending posts.\n";
has datetime => sub {
    my $self = shift;
    DateTime->now->set_time_zone($self->app->config->{skryfcfg}->{tz});
};

sub run {
    my ($self, $post) = @_;

    my $postdir = $self->app->config->{skryfcfg}->{post_directory};
    die "No post_directory configured\n" unless $postdir;
    $postdir = path(App::skryf::Util->sformat($postdir, bindir => $Bin));
    my $pendingdir = $postdir->child('pending');
    die "No pending post directory\n" unless $pendingdir->exists;

    unless (defined $post) {
        my ($choice, %enum);
        until ($choice) {
            my $idx;
            %enum = ();
            my $iter = $pendingdir->iterator;
            while (my $child = $iter->()) {
                my $basename = $child->basename;
                if ($basename =~ s/\.markdown$//) {
                    $enum{++$idx} = $basename;
                }
            }
            die "No pending posts\n" unless keys %enum;
            say "\nPending:\n";
            print map { ; "  $_ => " . $enum{$_} . "\n" } keys %enum;
            print "\nSelect a post number (or enter tag): ";
            $choice = <STDIN>;
            chomp $choice;
        }
        $post = $enum{$choice} // $choice;
    }

    my $file = $pendingdir->child($post . ".markdown");
    die "No such pending post $post\n"
      unless $file->exists;

    my $dest = $postdir->child($post . ".markdown");
    die "Post already published at $dest\n" if $dest->exists;

    system($ENV{EDITOR}, "$file");

    print "Publish now? [Y/n] ";
    my $ans = <STDIN>;
    chomp $ans;
    $ans = lc($ans || 'y');
    if ($ans eq 'y') {
        say "\nMoving to " . $dest->absolute;
        my @lines = $file->lines_utf8;
        for (@lines) {
            if (index($_, 'Date: ') == 0) {
                my $date = $self->datetime->datetime() . 'Z';
                $_ = "Date: $date\n";
                last;
            }
        }
        $dest->spew_utf8(@lines);
        say "Success! You may want to remove $file";
    }
    else {
        say "\nMove skipped; use 'repost $post' to edit";
    }
}
1;
