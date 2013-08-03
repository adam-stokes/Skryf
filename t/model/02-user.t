#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

diag("Testing user models");
use_ok('App::skryf::Model::User');
my $model;

my $username = 'joebob';
my $password = 'sillyman';

$model =
  App::skryf::Model::User->new(dsn => 'mongodb://localhost:27017/testdb');
ok $model;
ok $model->users;

ok $model->create(
  $username,
  $password,
);

ok $model->check($username, $password);

# Single post tests, basic add/update/delete/get
ok $model->remove($username);

done_testing();

