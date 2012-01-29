package Perl::Achievements::Command;

use strict;
use warnings;

use Moose;
use MooseX::SemiAffordanceAccessor;

use Path::Class qw/ dir file /;
use File::HomeDir;

extends qw/
    MooseX::App::Cmd::Command
    Perl::Achievements
/;


1;

