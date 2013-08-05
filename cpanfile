requires 'Carp';
requires 'File::ShareDir';
requires 'FindBin';
requires 'Mojo::Base';
requires 'Mojolicious::Lite';
requires 'Mojolicious::Plugin::Disqus::Tiny';
requires 'Mojolicious::Plugin::GoogleAnalytics';
requires 'Mojolicious::Plugin::Gravatar';
requires 'Mojolicious::Plugin::CSRFDefender';
requires 'Path::Tiny';
requires 'Text::Markdown';
requires 'Mango';
requires 'String::Dirify';
requires 'Method::Signatures';
requires 'DateTime';
requires 'DateTime::Format::RFC3339';

on develop => sub {
    requires 'Test::Pod', '1.41';
};
