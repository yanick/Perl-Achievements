package Perl::Achievements::Command::report;
# ABSTRACT: generates a report of one's achievements

use 5.10.0;

use strict;
use warnings;

=head1 SYNOPSIS

    perl-achievements report

=head1 DESCRIPTION

Produces a report of the glorious achievements of the user.
Currently the report is printed on STDOUT, and is in HTML.

=cut

use Moose;

extends 'Perl::Achievements::Command';

sub execute {
    my ( $self, $opt, $args ) = @_;

    print $self->generate_report( 'html' );
}

1;
