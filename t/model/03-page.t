#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag("Testing page model");
use_ok('App::skryf::Model::Page');

my $model;

my $topic = 'a wiki page';
my $slug = 'a-wiki-page';
my $content = '= heading 1';

$model = App::skryf::Model::Page->new;
ok $model;
ok $model->pages;
#cleanup
ok $model->pages->drop();
ok $model->create($topic, $content);
my $page = $model->get($slug);
ok $page;
ok $page->{html} =~ /^<h1>heading\s1<\/h1>/;
$page->{content} = '== heading 2';
ok $model->save($page);
ok $page->{html} =~ /^<h2>heading\s2<\/h2>/;
ok $model->remove($slug);

done_testing();
