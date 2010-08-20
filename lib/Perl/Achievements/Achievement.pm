package Perl::Achievements::Achievement;
BEGIN {
  $Perl::Achievements::Achievement::VERSION = '0.0.1';
}

use strict;
use warnings;

use Moose::Role;

use MooseX::Storage;

with Storage( format => 'YAML' );

use Perl::Achievements::UnlockedAchievement;

requires qw/ description /;

has 'app' => (
    traits => [ 'DoNotSerialize' ],
    required => 1,
    is => 'ro',
);

sub title {
    my $title = ref shift;
    $title =~ s/^.*:://;
    $title =~ s/([a-z])([A-Z])/$1 $2/g;

    return $title;
}

sub subtitle { undef }

sub details {  undef }

sub unlock_achievement {
    my $self = shift;

    $self->app->add_new_achievement(
    Perl::Achievements::UnlockedAchievement->new(
        title => $self->title,
        subtitle => $self->subtitle ,
        details => $self->details,
        description => $self->description,
        achievement => ref $self,
    ) );

}

1;

__END__
=pod

=head1 NAME

Perl::Achievements::Achievement

=head1 VERSION

version 0.0.1

=head1 AUTHOR

  Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

