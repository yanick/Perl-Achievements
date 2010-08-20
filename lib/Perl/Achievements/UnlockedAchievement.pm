package Perl::Achievements::UnlockedAchievement;

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
