package App::skryf::Command::import;

use Mojo::Base 'Mojolicious::Command';
use FindBin '$Bin';
use Carp;
use Path::Tiny;
use Data::Printer;
use App::skryf::Model::Post;

has description => "Import blog posts from another service\n";
has usage       => <<"EOF";

Usage: $0 import [service] [static posts]

[skryf|jekyll] service is required
  Supported Services:
    - jekyll/octopress
    - skryf (pre 0.009 releases)

EOF

sub run {
    my ($self, $service, @args) = @_;
    my $model = App::skryf::Model::Post->new;
    croak($self->usage) unless $service =~ /skryf|jekyll/;

    if ($service eq lc "skryf") {
      croak('Needs -d [posts] directory defined') unless $args[1];
      my $work_dir = path($args[1]);
      say "Starting import of posts in $args[1] ... Please wait.";
      for ($work_dir->children) {
        my $post = $_->slurp_utf8;
        my ($topic) = $post =~ /^Topic:\s+(.*)/;
        my ($date) = $post =~ /Date:\s+(.*)/;
        my ($tags) = $post =~ /Category:\s+(.*)/;
        my ($content) = $post =~ /^\n(.*)/ms;
        say "processing $topic";
        $model->create($topic, $content, $tags, $date);
      }
    }
    say
      "\nImport complete.";
}

1;
