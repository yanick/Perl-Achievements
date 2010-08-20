package Perl::Achievements::Achievement;

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
