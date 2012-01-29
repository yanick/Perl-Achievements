package Perl::Achievements::Achievement;

use strict;
use warnings;

use Moose::Role;

use MooseX::SemiAffordanceAccessor;

use YAML::Any qw/ LoadFile DumpFile /;
use DateTime::Functions qw/ now /;

with 'MooseX::ConfigFromFile';

requires qw/ scan /;

has 'app' => (
    required => 1,
    is => 'ro',
    handles => [ qw/ ppi log log_debug / ],
);

has level => (
    traits => [ 'Perl::Achievements::Role::ConfigItem', 'Number' ],
    isa => 'Num|Undef',
    is => 'rw',
    default => undef,
);

sub inc_level {
    my ( $self, $value ) = @_;
    $value ||= 1;
    $self->set_level(
        $self->level + $value
    );
}


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

    $self->app->unlock_achievement( 
        achievement => ref($self),
        timestamp => ''.now(),
        ( level => $self->level ) x ( $self->level > 0 ) ,
        ( details => $details ) x !!$details,
    );
}

before scan => sub {
    my $self = shift;
    $self->log_debug( "scanning for achievement " . ref $self );
};

after scan => sub {
    my $self = shift;

    $self->log_debug( 'storing state of ' . ref $self );

    $self->store( "".$self->app->rc_file_path( 
        'achievements', $self->storage_file ) );
};

sub pack {
    my $self = shift;

    my %data;

    for my $attr ( map { $self->meta->get_attribute($_) } 
                       $self->meta->get_attribute_list ) {
        next unless $attr->does('Perl::Achievements::Role::ConfigItem');

        my $name = $attr->name;
        $data{$name} = $self->$name;
    }

    return %data;
}

sub store {
    my $self = shift;

    my %data = $self->pack;
    DumpFile( shift, \%data );
}

1;
