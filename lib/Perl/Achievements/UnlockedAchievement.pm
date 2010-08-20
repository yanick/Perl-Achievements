package Perl::Achievements::UnlockedAchievement;
BEGIN {
  $Perl::Achievements::UnlockedAchievement::VERSION = '0.0.1';
}

use strict;
use warnings;

use Moose;

use MooseX::Storage;
use MooseX::Types::DateTime;
use DateTime;

with Storage( format => 'YAML' );

has 'title' => ( is => 'ro', );

has 'subtitle' => ( is => 'rw', );

has 'timestamp' => (
    isa     => 'DateTime',
    is      => 'ro',
    default => sub { DateTime->now },
    coerce => 1,
);

has 'details' => ( is => 'rw', );

has 'description' => ( is => 'ro', );

has 'achievement' => ( is => 'ro', );

sub pack {
    my $self = shift;

    return {
        timestamp => $self->timestamp->epoch,
        map { $_ => $self->$_ }
          qw/ title subtitle details description
          achievement /
    };

}

1;

__END__
=pod

=head1 NAME

Perl::Achievements::UnlockedAchievement

=head1 VERSION

version 0.0.1

=head1 AUTHOR

  Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

