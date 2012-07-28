use inc::Module::Install;

name     'Arduino-Watcher';
all_from 'lib/Arduino/Watcher.pm';
author   q{Peter Mayr <at.peter.mayr@gmail.com>};
license  'perl';

build_requires 'Test::More';

requires 'Moose';
requires 'Try::Tiny';
requires 'namespace::autoclean';
requires 'MooseX::Daemonize';
requires 'MooseX::Runnable';
requires 'MooseX::Log::Log4perl';
requires 'MooseX::SimpleConfig';
requires 'Device::SerialPort::Arduino';
requires 'LWP::UserAgent';
requires 'Log::Log4perl';
requires 'Config::Any::YAML';
requires 'CGI';

#install_script glob('bin/*.pl');
auto_install;

WriteAll;

