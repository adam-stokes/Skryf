use Rex::Lang::Perl::Perlbrew;
use Rex::Commands::Rsync;

die "No environment set." unless $ENV{BLAGGER_USER};

set perlbrew => root => "/home/$ENV{BLAGGER_USER}/perl5/perlbrew";

user $ENV{BLAGGER_USER};

group webserver => $ENV{BLAGGER_SERVER};

desc "Does a full software upgrade and dependency check";
task "upgrade",
  group => "webserver",
  sub {
    perlbrew -use => "perl-5.16.3";
    say "cpan update";
    run
      "cd /home/$ENV{BLAGGER_USER}/skryf && cpanm -q --notest --installdeps .";
    run "cd /home/$ENV{BLAGGER_USER}/skryf && dzil install";
    say "Restarting blog";
    run "ubic restart stokesblog";
  };

desc "Refresh templates";
task "refresh",
  group => "webserver",
  sub {
    perlbrew -use => "perl-5.16.3";
    say "Refreshing templates and software";
    run "cd /home/$ENV{BLAGGER_USER}/skryf && git pull";
};

desc "Sync posts";
task "deploy",
  group => 'webserver',
  sub {
    sync "$ENV{HOME}/posts/*", "/home/$ENV{BLAGGER_USER}/posts",
      {parameters => '--delete',};
  };
