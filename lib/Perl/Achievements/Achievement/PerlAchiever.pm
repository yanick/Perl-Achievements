package Perl::Achievements::Achievement::PerlAchiever;
# ABSTRACT: feeds code to perl-achiever

use strict;
use warnings;

use Moose;
use MooseX::SemiAffordanceAccessor;

no warnings qw/ uninitialized /;

with 'Perl::Achievements::Achievement';

has runs => (
    traits => [ qw/ Counter Perl::Achievements::Role::ConfigItem / ],
    isa     => 'Num',
    is      => 'rw',
    default => 0,
    handles => {
        inc_runs => 'inc',
    },
);

sub scan {
    my $self = shift;

    $self->inc_runs;

    return unless $self->runs >= 2** $self->level;

    $self->inc_level;
    $self->unlock( 
        sprintf "ran perl-achievements against %d scripts/modules",
                2 ** ( $self->level - 1 ) 
    );
}

1;
