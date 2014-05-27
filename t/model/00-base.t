#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin../../lib";

diag('Testing base model');
use_ok('Skryf::DB');

done_testing();
