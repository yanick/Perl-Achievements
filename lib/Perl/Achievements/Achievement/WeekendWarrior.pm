package Perl::Achievements::Achievement::WeekendWarrior;
# ABSTRACT: code over the week-end

use strict;
use warnings;

use Moose;
use MooseX::SemiAffordanceAccessor;

no warnings qw/ uninitialized /;

with 'Perl::Achievements::Achievement';

has days => (
    traits => [ qw/ Counter Perl::Achievements::Role::ConfigItem / ],
    isa     => 'Num',
    is      => 'rw',
    default => 0,
    handles => {
        inc_days => 'inc',
    },
);

sub scan {
    my $self = shift;

    my $wday = (localtime)[6];

    return unless $wday == 0 or $wday == 6;

    $self->inc_days;

    return unless $self->days >= 2**$self->level; 

    $self->inc_level;
    $self->unlock( 
        sprintf "Was at the computer %d days during week-ends", $self->days
    );
}

1;
