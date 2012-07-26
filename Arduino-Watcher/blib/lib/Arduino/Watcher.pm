package Arduino::Watcher;
use Moose;
use Try::Tiny;
use namespace::autoclean;
use strict;

our $VERSION = '0.1';

with qw(MooseX::Daemonize MooseX::Runnable);

sub run {
    my $self = shift;

    $self->start();
    exit(0);
}

after start => sub {
    my $self = shift;
    return unless $self->is_daemon();

    while (1) {
        try {

            # d
        };
    }

    sleep(3600);

};
1;    # End of Arduino::Watcher
