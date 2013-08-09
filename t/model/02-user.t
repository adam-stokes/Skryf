#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

diag("Testing user models");
SKIP: {
  eval { -x "/usr/bin/mongo" };
  skip "Mongo not installed", 5 if $@;
use_ok('App::skryf::Model::User');
my $model;

my $username = 'joebob';
my $password = 'sillyman';

$model =
  App::skryf::Model::User->new;
ok $model;
ok $model->users;

ok $model->create(
  $username,
  $password,
);

ok $model->check($username, $password);

#ok $model->remove($username);
}

done_testing();

