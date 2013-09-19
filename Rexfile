use Rex::Commands::Rsync;
use Carp;

croak("No server defined set.") unless $ENV{BLOGSERVER};

user $ENV{BLOGUSER} || "skryf";

group webserver => $ENV{BLOGSERVER};

desc "Restart blog service";
task "restart",
  group => "webserver",
  sub {
    say "Restarting blog";
    run "ubic restart stokesblog";
  };

desc "Does a full software upgrade and dependency check";
task "upgrade",
  group => "webserver",
  sub {
    say "cpan update";
    run "cpanm -q --notest App::skryf";
    do_task "restart";
  };
