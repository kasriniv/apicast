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

    my $ConfFile = $Test::Nginx::Util::ConfFile;
    my $Workers = $Test::Nginx::Util::Workers;
    my $MasterProcessEnabled = $Test::Nginx::Util::MasterProcessEnabled;
    my $DaemonEnabled = $Test::Nginx::Util::DaemonEnabled;
    my $err_log_file = $block->error_log_file || $Test::Nginx::Util::ErrLogFile;
    my $LogLevel = $Test::Nginx::Util::LogLevel;
    my $PidFile = $Test::Nginx::Util::PidFile;
    my $AccLogFile = $Test::Nginx::Util::AccLogFile;
    my $ServerPort = $Test::Nginx::Util::ServerPort;

    open my $out, ">apicast/config/test.lua" or Test::Nginx::Util::bail_out "Can't open $ConfFile for writing: $!\n";

    print $out <<_EOC_;
return {
    worker_processes = '$Workers',
    master_process = '$MasterProcessEnabled',
    daemon = '$DaemonEnabled',
    error_log = '$err_log_file',
    log_level = '$LogLevel',
    pid = '$PidFile',
    lua_code_cache = 'on',
    access_log = '$AccLogFile',
    port = { apicast = '$ServerPort' },
}
_EOC_
    close $out;

    my $apicast = `bin/apicast --test --environment test 2>&1`;
    if ($apicast =~ /configuration file (?<file>.+?) test is successful/)
    {
        move($+{file}, $Test::Nginx::Util::ConfFile);
    } else {
        warn "Missing config file: $Test::Nginx::Util::ConfFile";
        warn $apicast;
    }
   # FIXME: run bin/apicast to generate configuration
}

1;
