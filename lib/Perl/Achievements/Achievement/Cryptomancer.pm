package Perl::Achievements::Achievement::Cryptomancer;

use strict;
use warnings;

use Moose;

no warnings qw/ uninitialized /;

use List::MoreUtils qw/ uniq any/;

with 'Perl::Achievements::Achievement';

sub description { 'Used Perl magic variables.' };

has variables => (
    is => 'rw',
    default => sub { [] },
);

sub subtitle {
    my @vars = @{$_[0]->variables};
    return "Level " . @vars;
}

sub details {
    "Variables used: " . join ', ', @{$_[0]->variables};
}

sub check {
    my $self = shift;

    my $magic = $self->app->ppi->find( 'PPI::Token::Magic' ) or return;

    my @vars = @{ $self->variables };

    my @new_vars = uniq @vars, map { $_->content } @$magic;

    return if @vars == @new_vars;

    $self->variables( \@new_vars );

    $self->unlock_achievement;
}



1;



