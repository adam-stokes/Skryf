#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin../../lib";

diag('Testing base model');
use_ok('Skryf::DB');
my $model;

$model =
  Skryf::DB->new;
ok($model);
ok($model->namespace('test'));

done_testing();
