requires "Carp" => "0";
requires "DateTime" => "0";
requires "File::ShareDir" => "0";
requires "FindBin" => "0";
requires "List::Objects::WithUtils" => "0";
requires "Mojo::Base" => "0";
requires "Mojolicious::Lite" => "0";
requires "Mojolicious::Plugin::GoogleAnalytics" => "0";
requires "Mojolicious::Plugin::Gravatar" => "0";
requires "Path::Tiny" => "0";
requires "Pithub" => "0";
requires "Text::Markdown" => "0";
requires "perl" => "v5.16.3";
requires "strictures" => "1";

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
  requires "File::ShareDir::Install" => "0.03";
};
