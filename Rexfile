use Rex::Lang::Perl::Perlbrew;
use Rex::Commands::Rsync;

die "No environment set." unless $ENV{BLOGUSER};

set perlbrew => root => "/home/$ENV{BLOGUSER}/perl5/perlbrew";

user $ENV{BLOGUSER} || "skryf";

group webserver => $ENV{BLOGSERVER};

desc "Does a full software upgrade and dependency check";
task "upgrade",
  group => "webserver",
  sub {
    perlbrew -use => "perl-5.16.3";
    say "cpan update";
    run "cpanm -q --notest App::skryf";
    say "Restarting blog";
    run "ubic restart stokesblog";
  };

desc "Refresh templates";
task "refresh",
  group => "webserver",
  sub {
    perlbrew -use => "perl-5.16.3";
    say "Refreshing templates and software";
    run "cd /home/$ENV{BLOGUSER}/skryf && git pull";
  };

desc "Sync posts";
task "deploy",
  group => 'webserver',
  sub {
    sync "$ENV{HOME}/posts/*", "/home/$ENV{BLOGUSER}/posts",
      {parameters => '--delete',};
  };
