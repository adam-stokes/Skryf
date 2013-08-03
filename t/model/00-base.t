#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin../../lib";

use_ok('App::skryf::Model::Base');
my $model;

$model =
  App::skryf::Model::Base->new(dsn => 'mongodb://localhost:27017/testdb');
ok($model);
ok($model->mgo);

done_testing();
