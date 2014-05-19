#!/usr/bin/env perl

use Mojo::Base -strict;
use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag("Testing page model");
use_ok('Skryf::DB');

my $db;
my $model;

my $slug    = 'WikiWord';
my $content = 'WikiWord';

$db    = Skryf::DB->new;
$model = $db->namespace('pages');
ok $model;

#cleanup
ok $model->drop();
ok $model->insert({slug => $slug, content => $content});
my $page = $model->find_one({slug => $slug});
ok $page;
ok $page->{html} =~ /<a href="WikiWord">WikiWord<\/a>/;
ok $model->remove($slug);

done_testing();
