requires 'Carp';
requires 'File::ShareDir';
requires 'FindBin';
requires 'Mojo::Base';
requires 'Mojolicious';
requires 'Mojolicious::Plugin::Disqus::Tiny', '== 1.001';
requires 'Mojolicious::Plugin::GoogleAnalytics', '== 1.004';
requires 'Mojolicious::Plugin::Gravatar';
requires 'Mojolicious::Plugin::CSRFProtect';
requires 'Mojolicious::Plugin::HTMLLint';
requires 'Path::Tiny';
requires 'Text::MultiMarkdown';
requires 'Mango', '0.12';
requires 'String::Dirify';
requires 'Method::Signatures';
requires 'DateTime';
requires 'DateTime::Format::RFC3339';
requires 'XML::Atom::SimpleFeed';
requires 'String::Util';

on develop => sub {
    requires 'Test::Pod', '1.41';
    requires 'Test::Mojo';
};
