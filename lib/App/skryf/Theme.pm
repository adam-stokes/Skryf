package App::skryf::Theme;

use Mojo::Base 'Mojolicious::Plugin';
use Method::Signatures;

has theme_name        => 'Override_Me';
has theme_author      => 'Override_Me';
has theme_license     => 'Override_Me';
has theme_description => 'Override_Me';
has theme_active      => 0;

method meta {
    return {
        name        => $self->theme_name,
        author      => $self->theme_author,
        license     => $self->theme_license,
        description => $self->theme_description
    };
}
