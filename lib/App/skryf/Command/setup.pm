package App::skryf::Command::setup;

use strict;
use warnings;
use 5.014;
use FindBin '$Bin';
use Mojo::Base 'Mojolicious::Command';
use Path::Tiny;
use DateTime;

has description => "Setup your blog.\n";
has usage       => <<"EOF";

Usage: $0 setup [blog-name]

Blog-name is required and can be any alphanumeric characters.

EOF

sub run {
    my ($self, $blog_name) = @_;
    die $self->usage unless $blog_name;

    unless ($blog_name =~ /^[A-Za-z0-9_-]+$/) {
        die "Invalid blog name '$blog_name'\n",
          "Blog names should be in the 'a-z 0-9 _ -' set";
    }

    print "Would you like some default content to get you started? [Y/n] ";
    my $ans = <STDIN>;
    chomp $ans;
    $ans = lc($ans || 'y');
    if ($ans eq 'y') {
        say "\nInserting blog articles and some static content.";
    }
    say "\nBlog setup complete, run perldoc App::skryf for information on server configuration";
}

1;
