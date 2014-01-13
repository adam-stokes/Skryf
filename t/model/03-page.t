#!/usr/bin/env perl

use Mojo::Base -strict;
use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag("Testing page model");
use_ok('Skryf::Model::Page');

my $model;

my $slug = 'WikiWord';
my $content = 'WikiWord';

$model = Skryf::Model::Page->new;
ok $model;
ok $model->pages;
#cleanup
ok $model->pages->drop();
ok $model->create($slug, $content);
my $page = $model->get($slug);
ok $page;
ok $page->{html} =~ /<a href="WikiWord">WikiWord<\/a>/;
ok $model->remove($slug);

done_testing();
