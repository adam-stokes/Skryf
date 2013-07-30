requires 'Carp';
requires 'DateTime';
requires 'DateTime::Format::ISO8601';
requires 'File::ShareDir';
requires 'FindBin';
requires 'List::Objects::WithUtils';
requires 'Mojo::Base';
requires 'Mojolicious::Lite';
requires 'Mojolicious::Plugin::Disqus::Tiny';
requires 'Mojolicious::Plugin::GoogleAnalytics';
requires 'Mojolicious::Plugin::Gravatar';
requires 'Path::Tiny';
requires 'Pithub';
requires 'Text::Markdown';
requires 'Mango';
requires 'String::Dirify';

on develop => sub {
    requires 'Test::Pod', '1.41';
};
