requires "App::cpanminus" => "0";
requires "Carp" => "0";
requires "Class::Load" => "0";
requires "DateTime" => "0";
requires "DateTime::Format::RFC3339" => "0";
requires "Encode" => "0";
requires "File::Copy::Recursive" => "0";
requires "File::ShareDir" => "0";
requires "File::chdir" => "0";
requires "FindBin" => "0";
requires "IO::Prompt" => "0";
requires "Mango" => "0";
requires "Mojo::Base" => "0";
requires "Mojo::JSON" => "0";
requires "Mojo::Template" => "0";
requires "Mojo::UserAgent" => "0";
requires "Mojo::Util" => "0";
requires "Path::Tiny" => "0";
requires "Skryf::Model::Blog" => "0";
requires "String::Dirify" => "0";
requires "String::Util" => "0";
requires "Text::MultiMarkdown" => "0";
requires "XML::Atom::SimpleFeed" => "0";
requires "constant" => "0";
requires "feature" => "0";
requires "version" => "0";

on 'test' => sub {
  requires "List::Util" => "0";
  requires "Mojolicious" => "0";
  requires "Test::Mojo" => "0";
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
  requires "lib" => "0";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
  requires "File::ShareDir::Install" => "0.03";
};

on 'develop' => sub {
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
};
