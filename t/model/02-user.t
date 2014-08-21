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

my $username = 'joebob';
my $password = hmac_sha1_sum('password', 'sillyman');

$db = Skryf::DB->new;

my $params = {
    username => $username,
    password => $password,
    roles    => {admin => {is_admin => 1, is_owner => 1}}
};
ok $db->namespace('users')->save($params);

my $user_check = $db->namespace('users')->find_one({username => $username});
ok $username eq $user_check->{username};
ok $password eq $user_check->{password};
ok $db->namespace('users')->remove($user_check);

done_testing();
