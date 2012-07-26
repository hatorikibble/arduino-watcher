#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Arduino::Watcher' ) || print "Bail out!\n";
}

diag( "Testing Arduino::Watcher $Arduino::Watcher::VERSION, Perl $], $^X" );
