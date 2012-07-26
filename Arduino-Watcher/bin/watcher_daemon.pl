#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw!$Bin!;
use Config::Any::YAML;
use Data::Dumper;

use lib "$Bin/../lib";
use Arduino::Watcher;

my $config = Config::Any::YAML->load( $Bin . "/watcher.yml");



my $daemon = Arduino::Watcher->new_with_options($config);

my $opt_str = 'stop|start|status|restart';
my ($opt) = @{ $daemon->extra_argv };
if ( defined $opt and -1 < index $opt_str, $opt ) {
    $daemon->$opt;
    warn $daemon->status_message . "\n";
    exit $daemon->exit_code;

}
else {
    warn "usage: $0 {$opt_str}\n";
    exit -1;
}
