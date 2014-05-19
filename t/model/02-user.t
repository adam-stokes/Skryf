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
use_ok('Skryf::DB');
my $db;
my $model;

my $username = 'joebob';
my $password = hmac_sha1_sum('password', 'sillyman');

$db = Skryf::DB->new;
$model = $db->namespace('users');
ok $model;

ok $model->insert(
    {   username => $username,
        password => $password,
        attrs    => {
            launchpad => {
                token        => 'aaaa',
                token_secret => 'bbbb',
            },
        }
    }
);

my $user_check = $model->find_one({username => $username});
ok $username eq $user_check->{username};
ok $password eq $user_check->{password};

#ok $model->remove($username);

done_testing();

