package App::skryf::Model::Site;

use Mojo::Base 'App::skryf::Model::Base';
use Method::Signatures;
use Mango::BSON ':bson';

method site {
    $self->mgo->db->collection('site');
}

method create ($site, $title, $author, $contact, $description, $tz, $secret, $theme) {
    my $site_check = $self->site->find_one({title => $title});
    my $bson = bson_doc
      now         => bson_time,
      site        => $site,
      title       => $title,
      author      => $author,
      contact     => $contact,
      description => $description,
      tz          => $tz,
      secret      => $secret,
      theme       => $theme;

    if (!$site_check) {
        $self->site->insert($bson);
    }
    return 1;
}

method get {
    $self->site->find_one;
}

method save ($site) {
  $self->site->save($site);
}

1;
__END__

=head1 NAME

App::skryf::Model::Site - Site Model Skryf

=head1 DESCRIPTION

Site model

=head1 METHODS

=head2 B<site>

Grabs site collection from Mongo

=head2 B<create>

Creates a site configuration

=head2 B<get>

Gets single site configuration

=head2 B<save>

Saves site configuration

=head1 AUTHOR

Adam Stokes <adamjs@cpan.org>

=head1 COPYRIGHT

This plugin is copyright (c) 2013 by Adam Stokes

=head1 LICENSE

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>. L<Mango>

=cut
