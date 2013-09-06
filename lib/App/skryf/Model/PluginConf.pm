package App::skryf::Model::PluginConf;

use Mojo::Base 'App::skryf::Model::Base';
use Method::Signatures;
use Mango::BSON ':bson';

# Describe attributes
# name, description, options

method plugins {
    $self->mgo->db->collection('plugin');
}

method get ($plugin_id) {
    $self->plugins->find_one({_id => $plugin_id});
}

method save ($plugin) {
    $self->plugins->save($plugin);
}

method all ($enabled = bson_true) {
  $self->plugins->find({enabled => bson_true})->all;
}

1;
__END__

=head1 NAME

App::skryf::Model::PluginConf - Skryf Model

=head1 DESCRIPTION

Model routines for altering plugin attributes.

=head1 METHODS

=head2 plugins

Grab plugins collection

=head2 get

Get single plugin record

=head2 save

Save plugin attributes to collection

=head2 all

List all available and enabled Plugins.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 LICENSE

Licensed under the same terms as Perl.

=head1 SEE ALSO

L<App::skryf>

=cut
