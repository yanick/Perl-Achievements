package Perl::Achievements::Role::Report;

use strict;
use warnings;

use Moose::Role;

requires qw/ generate /;

has who => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

1;
