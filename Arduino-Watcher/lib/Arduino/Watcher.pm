package Arduino::Watcher;

=head1 NAME

B<Arduino::Watcher> - liest Lastlevels aus einem CGI Skript und leitet diese an einen Arduino weiter

=head1 SYNOPSIS


 my $daemon = Arduino::Watcher->new_with_options(
    pidbase              => "$Bin/run",

    # watcher params
    load_url         => 'http://host.com/cgi-bin/load',
    interval         => 10,
    orange_threshold => 2,
    red_threshold    => 5,

    debug => 1,
);


=head1 AUTHOR

Peter Mayr <at.peter.mayr@gmail.com>

=head1 VERSION

0.1

=head1 METHODS


=head2 new_with_options( load_url => 'http://host.com/cgi-bin/load', interval => 10);

the following parameters are accepted

=over

=item * pidbase (optional):

Verzeichnis in which the PID File is created

=item * arduino_port

device path for the arduino

=item * load_url

Location of the CGI script

=item * interval (optional)

interval in which load_url is polled, default is 10 seconds

=item * orange_threshold

load to set the LED to orange

=item * red_threshold

load to set the LED to red

=item * debug

debug flag, if set no output to Arduino is written

=back

=cut

our $VERSION = '0.1';

use namespace::autoclean;
use strict;

use Moose;

use Device::SerialPort::Arduino;
use FindBin qw($Bin);
use Log::Log4perl qw( :levels);
use LWP::Simple;
use Try::Tiny;


use namespace::autoclean;
use strict;



with qw(MooseX::SimpleConfig MooseX::Getopt MooseX::Log::Log4perl MooseX::Daemonize MooseX::Runnable  );

#with qw(MooseX::Daemonize MooseX::Runnable  );
has 'dont_close_all_files' => (is => 'ro', isa=>'Bool', default=>1);
has 'debug' => (is => 'ro', isa=>'Bool', default=>0);
has 'arduino_port'  => ( is => 'ro', isa => 'Str', default  => '/dev/ttyACM0' );
has 'load_url' => ( is => 'ro', isa => 'Str', required => 1 );
has 'interval' => ( is=> 'ro', isa=>'Int', default=>10 );
has 'orange_threshold' => ( is=> 'ro', isa=>'Int', default=>2 );
has 'red_threshold' => ( is=> 'ro', isa=>'Int', default=>5 );

Log::Log4perl::init($Bin.'/logging.conf');

=head2 run

called by the perl script

=cut

sub run {
    my $self = shift;

    $self->start();
    exit(0);
}

after start => sub {
    my $self    = shift;
    my $load    = undef;
    my $msg     = undef;
    my $Arduino = undef;

    unless ( $self->debug ) {
        $Arduino = Device::SerialPort::Arduino->new(
            port     => $self->arduino_port,
            baudrate => 9600,

            databits => 8,
            parity   => 'none',
        );
    }
    return unless $self->is_daemon();

    $self->log->info("Daemon started..");
    $self->log->debug(   "Verwende URL: "
                       . $self->load_url
                       . ", Intervall: "
                       . $self->interval );
    while (1) {
        try {

            $load = get $self->load_url;

            if ( $load > $self->red_threshold ) {
                $self->log->error("Load ist $load");
                $msg = "r";
            }
            elsif ( $load > $self->orange_threshold ) {
                $self->log->warn("Load ist $load");
                $msg = "o";
            }
            else {
                $self->log->debug("Load ist $load");
                $msg = "g";
            }
            $Arduino->communicate($msg) unless ( $self->debug );
            sleep( $self->interval );
        };
    }

    sleep(3600);

};

before stop => sub {
    my $self = shift;
    $self->log->info("Daemon ended..");
};

__PACKAGE__->meta->make_immutable;

1;    # End of Arduino::Watcher
