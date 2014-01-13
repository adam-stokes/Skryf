#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin../../lib";

diag('Testing base model');
use_ok('Skryf::Model::Base');
my $model;

$model =
  Skryf::Model::Base->new;
ok($model);
ok($model->mgo);

done_testing();
