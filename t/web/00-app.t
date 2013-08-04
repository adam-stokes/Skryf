#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin../../lib";

use Test::More;
use Test::Mojo;

diag('Testing application functionality');
my $t = Test::Mojo->new('App::skryf');

$t->get_ok('/')->status_is(200)->content_like(qr/Root/, 'right content');
$t->get_ok('/login')->status_is(200)
  ->content_like(qr/name="username"/, 'right content');
$t->get_ok('/logout')->status_is(302);
$t->get_ok('/admin/post')->status_is(302);
$t->post_ok(
    '/auth' => form => {
        username  => 'joebob',
        password  => 'sillyman',
    }
)->status_is(302);
$t->get_ok('/admin/post')->status_is(200)
  ->content_like(qr/Administer pages\/posts/, 'right content');

# Post new topic
$t->post_ok(
    '/admin/post/new' => form => {
        topic   => 'a new topic',
        content => 'auto content posted',
        tags    => 'ubuntu, blog, test',
    }
)->status_is(302);

$t->get_ok('/post/a-new-topic')->status_is(200)
  ->content_like(qr/auto content posted/, 'right content');

$t->get_ok('/post/feeds/ubuntu/atom.xml')->status_is(200);
$t->get_ok('/admin/post/delete/a-new-topic')->status_is(302);

done_testing();
