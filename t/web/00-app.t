#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin../../lib";

use Test::More;
use Test::Mojo;

diag('Testing application functionality');
my $t = Test::Mojo->new('App::skryf');

ok $t;
ok $t->get_ok('/')->status_is(200);

done_testing();
