package App::skryf::Plugin::Search::Controller;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::UserAgent;
use Mojo::JSON;
use Method::Signatures;

method search_index {
    my $method = $self->req->method;
    $self->stash(results => undef);
    if ($method eq 'POST') {
        my $ua   = Mojo::UserAgent->new;
        my $json = Mojo::JSON->new;
        my $url =
            "http://tapirgo.com/api/2/search.json?token="
          . $self->config->{social}{tapir}
          . '&query='
          . $self->param('search_query');
        my $results = $ua->get($url)->res->json;
        $self->stash(results => $results);
        $self->render('search/index');
    }
    else {
        $self->render('search/index');
    }
}

1;
