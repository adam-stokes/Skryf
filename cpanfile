requires "App::skryf::Plugin::Admin", '0.02' => git =>
  'git@github.com:skryf/App-skryf-Plugin-Admin.git';
requires "App::skryf::Plugin::Blog", '0.02' => git =>
  'git@github.com:skryf/App-skryf-Plugin-Blog.git';
requires "App::skryf::Theme::Booshka", '0.02', git => 'git@github.com:skryf/App-skryf-Theme-Booshka.git';
requires 'Class::Load';
requires 'DDP';
requires 'DateTime';
requires 'DateTime::Format::RFC3339';
requires 'Encode';
requires 'File::ShareDir';
requires 'IO::Prompt';
requires 'List::Util';
requires 'Mango';
requires 'Mango::BSON';
requires 'Mojo::Base';
requires 'Mojo::Util';
requires 'Mojolicious::Commands';
requires 'Path::Tiny';
requires 'String::Dirify';
requires 'String::Util';
requires 'Test::Mojo';
requires 'Test::More';
requires 'Text::MultiMarkdown';
requires 'XML::Atom::SimpleFeed';

on test => sub {
  requires 'Test::More';
  requires 'Test::Mojo';
};

on build => sub {
  requires 'Test::More';
  requires 'Test::Mojo';
};
