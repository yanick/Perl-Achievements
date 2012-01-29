package Perl::Achievements::Achievement;

use strict;
use warnings;

use Moose::Role;

use MooseX::Storage;
use MooseX::SemiAffordanceAccessor;
use YAML::Any qw/ LoadFile /;

with 'MooseX::ConfigFromFile';
with Storage( format => 'YAML', io => 'File' );

requires qw/ scan /;

has '+configfile' => (
    'traits' => [ 'DoNotSerialize' ],
);

has 'app' => (
    traits => [ 'DoNotSerialize' ],
    required => 1,
    is => 'ro',
    handles => [ qw/ ppi log log_debug / ],
);

has level => (
    traits => [ 'Number' ],
    isa => 'Num|Undef',
    is => 'rw',
    default => undef,
    handles => {
        inc_level => [ add => 1 ],
    },
);

sub get_config_from_file {
    my ( $class, $file ) = @_;

    return -f $file ? LoadFile( $file ) : {};
}

sub storage_file {
    my $class = shift;

    # if object, turn to class name
    $class = ref $class if ref $class;

    $class =~ s/^Perl::Achievements::Achievement:://;
    $class =~ s/::/__/g;
    $class .= '.yaml';

    return $class;
}

sub load_or_new {
    my ( $class, %args ) = @_;

    my $file = $args{app}->rc_file_path( 'achievements', $class->storage_file );

    return $class->new_with_config( configfile => $file, %args );
}

sub unlock {
    my ($self, $details ) = @_;

    $self->app->unlock_achievement( $self, $details );
}

after scan => sub {
    my $self = shift;

    $self->log_debug( 'storing state of ' . ref $self );

    $DB::single = 1;
    $self->pack;

    $self->store( "".$self->app->rc_file_path( 
        'achievements', $self->storage_file ) );
};

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
