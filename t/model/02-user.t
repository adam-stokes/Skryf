#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 6;

use FindBin;
use lib "$FindBin::Bin../../lib";

use_ok('App::skryf::Model::User');
my $model;

my $username = 'joebob';
my $password = 'sillyman';

$model =
  App::skryf::Model::User->new(dsn => 'mongodb://localhost:27017/testdb');
ok $model;
ok $model->users;

diag("Creating user");
ok $model->create(
  $username,
  $password,
);

ok $model->check($username, $password);

# Single post tests, basic add/update/delete/get
diag('Deleting user');
ok $model->remove($username);

