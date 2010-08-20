package Perl::Achievements::Achievement::PerlHacker;
BEGIN {
  $Perl::Achievements::Achievement::PerlHacker::VERSION = '0.0.1';
}

use strict;
use warnings;

use Perl::Achievements::Achievement;

use Moose;

no warnings qw/ uninitialized /;

with 'Perl::Achievements::Achievement';

has locs => (
    traits  => ['Number'],
    isa     => 'Num',
    is      => 'rw',
    handles => { add_locs => 'add', },
);

has level => (
    traits => ['Number'],
    isa => 'Num',
    is      => 'rw',
    default => 0,
    handles => { inc_level => [ add => 1 ] },
);

sub title { 'Just Another Perl Hacker' }

sub subtitle { "Level " . $_[0]->level }

sub details { "Ran >" . 10**$_[0]->level . " LOCs." }

sub description { 'Did what Perl hackers do: run code.' }

sub check {
    my $self = shift;

    my @lines = split "\n", $self->app->ppi->serialize;
    $self->add_locs( scalar @lines );

    if ( $self->locs > 10 ** (1+$self->level) ) {
        $self->inc_level;
        $self->unlock_achievement;
    }

}

1;

__END__
=pod

=head1 NAME

Perl::Achievements::Achievement::PerlHacker

=head1 VERSION

version 0.0.1

=head1 AUTHOR

  Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

