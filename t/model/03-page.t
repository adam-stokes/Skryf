#!/usr/bin/env perl

use Mojo::Base -strict;
use Test::More;

use FindBin;
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

note("Testing page model");
use_ok('Skryf::DB');

my $db;
my $model;

my $slug    = 'WikiWord';
my $content = 'WikiWord';

$db    = Skryf::DB->new;
$model = $db->model('Skryf::Model::Page');
ok $model;
ok $model->collection eq 'pages';

#cleanup
ok $model->save({slug => $slug, content => $content});
my $page = $model->find_page({slug => $slug});
ok $page->{html} =~ /<a href="WikiWord">WikiWord<\/a>/;
ok $model->remove_page($page);

done_testing();
