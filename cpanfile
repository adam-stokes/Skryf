requires 'Class::Load';
requires 'DDP';
requires 'DateTime';
requires 'DateTime::Format::RFC3339';
requires 'Encode';
requires 'File::ShareDir';
requires 'File::chdir';
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
requires 'version';

on test => sub {
  requires 'Test::More';
  requires 'Test::Mojo';
};

on build => sub {
  requires 'Test::More';
  requires 'Test::Mojo';
};
