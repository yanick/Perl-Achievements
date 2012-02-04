package Perl::Achievements::User;

use strict;
use warnings;

use Moose;

has name => (
    is => 'ro',
    isa => 'Str',
);

has url => (
    is => 'ro',
    isa => 'Str',
);

1;
