#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use FindBin;
use List::Util qw(first);
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag("Testing posts model");
use_ok('Skryf::Model::Post');
my $model;

my $topic_a      = 'a sluggable test post';
my $topic_a_slug = 'a-sluggable-test-post';
my $topic_b      = 'an updated test post';
my $topic_b_slug = 'an-updated-test-post';
my $tags         = 'ubuntu, test, blog';

$model = Skryf::Model::Post->new;
ok $model;
ok $model->posts;
# cleanup
ok $model->posts->drop();
ok $model->create($topic_a, 'some content for the test', $tags,);
my $post = $model->get($topic_a_slug);
ok $post;
ok $post->{topic} eq $topic_a;
$post->{topic} = $topic_b;
ok $model->save($post);
$post = $model->get($topic_b_slug);
ok $post;
ok $post->{topic} eq $topic_b;
ok $post->{slug} eq $topic_b_slug;
my $post_by_cat = $model->by_cat('ubuntu');
ok scalar @{$post_by_cat} > 0;
ok $post_by_cat;
ok ref $post_by_cat eq "ARRAY";
ok $model->remove($topic_b_slug);

done_testing();
