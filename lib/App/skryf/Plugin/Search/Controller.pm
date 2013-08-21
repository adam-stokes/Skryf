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
__END__

=head1 NAME

App::skryf::Plugin::Search::Controller - Search plugin controller

=head1 DESCRIPTION

Search controller

=head1 CONTROLLERS

=head2 B<search_index>

Renders search page

=cut
