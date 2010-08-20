package Perl::Achievements;
BEGIN {
  $Perl::Achievements::VERSION = '0.0.1';
}
# ABSTRACT: whoever die() with the most badges win

use strict;
use warnings;

use Moose;

no warnings qw/ uninitialized /;

use MooseX::Storage;
use Module::Pluggable
  search_path => ['Perl::Achievements::Achievement'],
  require     => 1;
  use YAML::Any;
  use PPI;

with Storage( format => 'YAML', io => 'File' );

has _achievements => (
    traits => [ 'Array' ], 
    is      => 'ro',
    builder => '_achievements_builder',
    handles => {
        achievements => 'elements',
        add_achievements => 'push',
    },
);

has _new_achievements => (
    traits => [ 'Array' ], 
    is      => 'rw',
    default => sub { [] },
    handles => {
        new_achievements => 'elements',
        add_new_achievement => 'push',
    },
);

has _unlocked_achievements => (
    traits => [ 'Array' ],
    default => sub{ [] },
    is => 'ro',
    handles => {
        unlocked_achievements => 'elements',
        add_unlocked_achievements => 'push',
    },
);

has rc => (
    is => 'ro',
    default => sub { $ENV{HOME} . '/.perl-achievements' },
);

has ppi => (
    traits => [ qw/ DoNotSerialize / ],
    is => 'rw',
);

sub BUILD {
    my $self = shift;

    return unless -f $self->rc;

    my $ref = YAML::Any::LoadFile( $self->rc );

    for ( @{ $ref->{_unlocked_achievements} } ) {
        $self->add_unlocked_achievements(
            Perl::Achievements::UnlockedAchievement->new( %$_ ) );
    }

    for my $achievement ( @{ $ref->{_achievements} } ) {
        my ( $ach ) = grep { ref($_) eq $achievement->{'__CLASS__'} } $self->achievements
            or next;
        while( my( $k, $v ) = each %$achievement ) {
            next if $k eq '__CLASS__';
            $ach->$k( $v );
        }
    }


}

sub run {
    my ( $self, @args ) = @_;

    $self->peruse( @args );

    exec 'perl', @args;
}

sub peruse {
    my ( $self, @args ) = @_;

    my $file = $args[-1];

    $self->ppi( PPI::Document->new( $file ) );

    my @new_achievements = map { $_->check } $self->achievements;

    if ( my @new_achievements = $self->new_achievements ) {
        $self->advertise( @new_achievements );
        $self->add_unlocked_achievements( @new_achievements );
    }

    $self->store( $self->rc );
}

sub list_achievements {
    my $self = shift;

    for ( $self->unlocked_achievements ) {
        print join " - ", $_->timestamp->date, $_->title;
        print " - ", $_->subtitle if $_->subtitle;
        print "\n";
    }

}

sub _achievements_builder {
    my $self = shift;

    my @checks;

    push @checks, $_->new( app => $self ) for $self->plugins;

    return \@checks;
}

sub advertise {
    my $self = shift;
    my @achievements = @_;

    warn "Congrats! You have unlocked ", scalar( @achievements ), 
        " new achievement", 's'x(@achievements>1), "\n\n";

    for ( @achievements ) {
        warn '*' x 60, "\n";
        warn '*** ', $_->title, "\n";
        warn '*** ', $_->subtitle, "\n" if $_->subtitle;
        warn "\n";
        warn $_->description, "\n";
        warn "\n", $_->details, "\n" if $_->details;
    }

    warn '*' x 60, "\n";

}

1;

__END__
=pod

=head1 NAME

Perl::Achievements - whoever die() with the most badges win

=head1 VERSION

version 0.0.1

=head1 AUTHOR

  Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

