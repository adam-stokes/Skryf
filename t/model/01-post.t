#!/usr/bin/env perl

use strict;
use warnings;
use Data::Printer;
use Test::More tests => 12;

use FindBin;
use lib "$FindBin::Bin../../lib";

use_ok('App::skryf::Model::Post');
my $model;

my $topic_a = 'a sluggable test post';
my $topic_a_slug = 'a-sluggable-test-post';
my $topic_b = 'an updated test post';
my $topic_b_slug = 'an-updated-test-post';

$model =
  App::skryf::Model::Post->new(dsn => 'mongodb://localhost:27017/testdb');
ok $model;
ok $model->posts;

diag("Creating post");
ok $model->create(
  $topic_a,
    'some content for the test',
    'a few, tags, for, test'
);

ok $model->all;

# Single post tests, basic add/update/delete/get
diag('Getting post');
my $post = $model->get($topic_a_slug);
ok $post;
ok $post->{topic} eq $topic_a;
$post->{topic} = $topic_b;
diag('Saving routine');
ok $model->save($post);

diag('Re-query for updated post');
$post = $model->get($topic_b_slug);
ok $post;
ok $post->{topic} eq $topic_b;
ok $post->{slug} eq $topic_b_slug;

diag('Removing post');
ok $model->remove($topic_b_slug);

