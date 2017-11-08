package TestAPIcastBlackbox;
use strict;
use warnings FATAL => 'all';
no warnings qw(redefine);
use v5.10.1;

use lib 't';
use TestAPIcast  -Base;
use File::Copy "move";


sub Test::Nginx::Util::write_config_file ($$) {
    my ($block, $config) = @_;

    my $apicast = `bin/apicast --test 2>&1`;
    if ($apicast =~ /configuration file (?<file>.+?) test is successful/)

    {
        move $+{file}, $Test::Nginx::Util::ConfFile;
    } else {
        warn "Missing config file: $Test::Nginx::Util::ConfFile";
    }
   # FIXME: run bin/apicast to generate configuration
}

1;
