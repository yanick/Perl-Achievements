package Perl::Achievements::Command;

use strict;
use warnings;

use Moose;
use MooseX::SemiAffordanceAccessor;

use Path::Class qw/ dir file /;
use File::HomeDir;

extends qw/
    MooseX::App::Cmd::Command
    Perl::Achievements
/;

has verbose => (
    isa => 'Bool',
    is => 'ro',
);

sub BUILDARGS {
    my $self = shift;

    my %args = @_ == 1 ? %{$_[0]} : @_;

    my @args = %args;

    unshift @args, debug => 1, log_to_stdout => 1 if $args{verbose};

    $self->SUPER::BUILDARGS( @args );
}


1;

