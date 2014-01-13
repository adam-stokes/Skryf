#!/usr/bin/env perl

use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use FindBin;
use lib "$FindBin::Bin../../lib";

plan skip_all => 'set TEST_ONLINE to enable this test'
  unless $ENV{TEST_ONLINE};

diag('Testing application functionality');
my $t = Test::Mojo->new('Skryf');

# Get token
my $csrftoken =
  $t->ua->get('/')->res->dom->at('meta[name=csrftoken]')->attr('content');

# Add header with csrftoken to every request automatically
$t->ua->on(
    start => sub {
        my ($ua, $tx) = @_;
        $tx->req->headers->header('X-CSRF-Token', $csrftoken);
    }
);

# verify we can get to some pages
$t->get_ok('/')->status_is(200)->content_like(qr/Root/, 'i see homepage');
$t->get_ok('/admin/post')->status_is(302);

# login
$t->get_ok('/login')->status_is(200)
  ->content_like(qr/name="csrftoken"/, 'i see login page with csrftoken');
$t->post_ok(
    '/auth' => form => {
        csrftoken => $csrftoken,
        username  => 'adam',
        password  => 'password',
    }
)->status_is(302);

# see if we have access to admin section
$t->get_ok('/admin/post')->status_is(200)
  ->content_like(qr/Skryf::Admin/, 'i see admin page');

# Post new topic
$t->post_ok(
    '/admin/post/new' => form => {
        topic   => 'a new topic',
        content => 'auto content posted',
        tags    => 'ubuntu, blog, test',
    }
)->status_is(302);

$t->get_ok('/post/a-new-topic')->status_is(200)
  ->content_like(qr/auto content posted/, 'new topic posted');

# take a look at the feeds
$t->get_ok('/post/feeds/ubuntu/atom.xml')->status_is(200)
  ->content_like(qr/auto content posted/, 'xml content found');
$t->get_ok('/post/feeds/atom.xml')->status_is(200)
  ->content_like(qr/auto content posted/, 'xml content found');

# update the post and verify it is updated and the feeds are corrected
$t->post_ok(
    '/admin/post/update' => form => {
        slug    => 'a-new-topic',
        topic   => 'a new topic edited',
        content => 'auto content posted',
        tags    => 'ubuntu, blog, test',
    }
)->status_is(302);

$t->get_ok('/post/a-new-topic-edited')->status_is(200)
  ->content_like(qr/a new topic edited/, 'edited content found');
$t->get_ok('/post/feeds/atom.xml')->status_is(200)
  ->content_like(qr/auto content posted/, 'xml updated feed content found');

# delete it
$t->get_ok('/admin/post/delete/a-new-topic-edited')->status_is(302);
$t->get_ok('/logout')->status_is(302);

done_testing();
