package Skryf::Role::Page;

# ABSTRACT: Skryf page model

use Skryf::Util;
use DateTime;

use constant USE_WIKILINKS => 1;
use Moo::Role;

sub pre_save {
    my ($self, $params) = @_;
    my $created = $params->{created} // DateTime->now;
    $params->{html} = Skryf::Util->convert($params->{content}, USE_WIKILINKS);
    $params->{created} = $created->strftime('%Y-%m-%dT%H:%M:%SZ');
    return $params;
}

1;

__END__

=head1 DESCRIPTION

Page model

=cut
