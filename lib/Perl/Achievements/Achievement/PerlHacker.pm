package Perl::Achievements::Achievement::PerlHacker;

use strict;
use warnings;
no warnings qw/ uninitialized /;

use Moose;

with 'Perl::Achievements::Achievement';

has locs => (
    traits  => ['Number'],
    isa     => 'Num',
    is      => 'rw',
    handles => { add_locs => 'add', },
);

sub title { 'Just Another Perl Hacker' }

sub subtitle { "Level " . $_[0]->level }

sub details { "Ran >" . 10**$_[0]->level . " LOCs." }

sub description { 'Did what Perl hackers do: run code.' }

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
