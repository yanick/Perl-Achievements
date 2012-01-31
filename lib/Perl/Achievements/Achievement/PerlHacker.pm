package Perl::Achievements::Achievement::PerlHacker;
# ABSTRACT: just another Perl hacker

use strict;
use warnings;

use Moose;

no warnings qw/ uninitialized /;

with 'Perl::Achievements::Achievement';

has locs => (
    traits => [ qw/ Number Perl::Achievements::Role::ConfigItem / ],
    isa     => 'Num',
    is      => 'rw',
    handles => { add_locs => 'add', },
);

sub scan {
    my $self = shift;

    my @lines = split "\n", $self->ppi->serialize;
    $self->add_locs( scalar @lines );

    if ( $self->locs > 10 ** (1+$self->level) ) {
        $self->inc_level;
        $self->unlock;
    }

}

1;
