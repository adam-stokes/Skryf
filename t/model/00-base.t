#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

use_ok('App::skryf::Model::Base');
my $model;

$model = App::skryf::Model::Base->new;
ok($model);

my $dsn = 'mongodb://localhost:27017';
my $db = $model->db($dsn);
ok($db);
ok($db->users);
ok($db->blog);

done_testing();
