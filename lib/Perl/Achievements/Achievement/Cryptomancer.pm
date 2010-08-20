package Perl::Achievements::Achievement::Cryptomancer;
BEGIN {
  $Perl::Achievements::Achievement::Cryptomancer::VERSION = '0.0.1';
}

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




__END__
=pod

=head1 NAME

Perl::Achievements::Achievement::Cryptomancer

=head1 VERSION

version 0.0.1

=head1 AUTHOR

  Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

