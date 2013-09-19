#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../../../lib" }

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag("Testing user models");
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
    {   launchpad => {
            token        => 'aaaa',
            token_secret => 'bbbb',
        },
    },
);

#ok $model->remove($username);

done_testing();

