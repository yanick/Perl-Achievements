package Perl::Achievements::Command::init;
# ABSTRACT: initializes the perl-achievements environment

use 5.10.0;

=head1 SYNOPSIS

    perl-achievement init [ --rc $dir ]

=head1 DESCRIPTION

Creates the directory where the configuration and the state
of C<perl-achievements> will be kept. 

If the directory is not explicitly given via the argument I<--rc> , defaults to 
(if defined) the environment variable I<PERL_ACHIEVEMENTS_HOME>,
or I<$HOME/.perl_achievements>.

=cut

use 5.10.0;

use strict;
use warnings;

use Path::Class qw/ file /;

use Moose;

extends 'Perl::Achievements::Command';

sub execute {
    my $self = shift;

    $self->initialize_environment;

    say $self->rc, ' created';

    say "you might want to edit ", file( $self->rc, 'config' ), 
        " with your name and information";
}


1;
