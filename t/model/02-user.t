#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Mojo::Util qw(hmac_sha1_sum);

use FindBin;
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag("Testing user models");
use_ok('App::skryf::Model::User');
my $model;

my $username = 'joebob';
my $password = hmac_sha1_sum('password', 'sillyman');

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

my $user_check = $model->get($username);
ok $username eq $user_check->{username};
ok $password eq $user_check->{password};
#ok $model->remove($username);

done_testing();

