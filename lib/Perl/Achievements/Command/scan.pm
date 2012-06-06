package Perl::Achievements::Command::scan;
# ABSTRACT: inspects scripts/modules for achievements

use 5.10.0;

=head1 SYNOPSIS

    perl-achievement scan <files...>

=head1 DESCRIPTION

Inspects the given files for achievements.

=cut

use strict;
use warnings;

use Moose;

extends 'Perl::Achievements::Command';

sub execute {
    my ( $self, undef, $args ) = @_;

    for ( @$args ) {
        $self->log_debug( "scanning '$_'..." );
        $self->scan( $_ );
    }
}

1;
