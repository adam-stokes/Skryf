package App::skryf::Plugin::Search;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

use App::skryf::Plugin::Search::Controller;

my %defaults = (
    indexPath   => '/search/',
    namespace   => 'App::skryf::Plugin::Search::Controller',
);

sub register {
    my ($self, $app) = @_;
    my (%conf) = (%defaults, %{$_[2] || {}});

    $app->helper(search => sub { \%conf });
    $app->routes->route($conf{indexPath})->via(qw(GET POST))->to(
        namespace    => $conf{namespace},
        action       => 'search_index',
        _search_conf => \%conf,
    )->name('search_index');
    return;
}

1;
