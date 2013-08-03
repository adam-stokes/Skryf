package App::skryf::Command::setup;

use strict;
use warnings;
use 5.014;
use FindBin '$Bin';
use Mojo::Base 'Mojolicious::Command';
use Carp;
use Path::Tiny;
use DateTime;
use App::skryf::Model::User;

has description => "Setup your blog.\n";
has usage       => <<"EOF";

Usage: $0 setup [name]

[Name] is required and can be any alphanumeric characters.

EOF

sub run {
    my ($self, $blog_name) = @_;
    my $model = App::skryf::Model::User->new;
    die $self->usage unless $blog_name;

    unless ($blog_name =~ /^[A-Za-z0-9_-]+$/) {
        croak "Invalid blog name '$blog_name'\n",
          "Blog names should be in the 'a-z 0-9 _ -' set";
    }

    print "User setup";
    print "\nUsername: ";
    my $username = <STDIN>;
    chomp $username;
    print "Password: ";
    my $password = <STDIN>;
    chomp $password;
    if ($model->get({username => $username})) {
        croak
          "The user: $username already exists in the database.\n",
          "Please remove if you wish to re-auth";
    }
    $model->create($username, $password);
    say
      "\nBlog setup complete, run perldoc App::skryf ",
      "for information on server configuration";
}

1;
