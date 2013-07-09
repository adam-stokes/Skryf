package App::skryf::Util;

use strictures 1;

sub sformat {
    my ($class, $string) = splice @_, 0, 2;
    return '' unless defined $string and length $string;
    my %vars = (homedir => $ENV{HOME}, @_);
    my $rpl = sub {
        my ($orig, $match) = @_;
        return $orig unless defined $vars{$match};
        ref $vars{$match} eq 'CODE'
          ? $vars{$match}->($match, $orig, $vars{$match})
          : $vars{$match};
    };
    my $re = qr/(%([^\s%]+)%?)/;
    $string =~ s/$re/$rpl->($1,$2)/ge;
    $string;
}

1;
