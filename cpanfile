requires "Carp" => "0";
requires "Class::Load" => "0";
requires "DateTime" => "0";
requires "DateTime::Format::RFC3339" => "0";
requires "Encode" => "0";
requires "File::Copy::Recursive" => "0";
requires "File::ShareDir" => "0";
requires "File::chdir" => "0";
requires "FindBin" => "0";
requires "Hash::Merge" => "0";
requires "IO::Prompt" => "0";
requires "Mojolicious" => "8.20";
requires "Role::Tiny" => "2";
requires "Path::Tiny" => "0";
requires "String::Dirify" => "0";
requires "String::Util" => "0";
requires "Text::MultiMarkdown" => "0";
requires "XML::Atom::SimpleFeed" => "0";
requires "constant" => "0";

on 'test' => sub {
  requires "Mojolicious" => "0";
  requires "Test::Mojo" => "0";
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
  requires "lib" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::ShareDir::Install" => "0.06";
};

on 'develop' => sub {
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
  requires "Test::Synopsis" => "0";
};
