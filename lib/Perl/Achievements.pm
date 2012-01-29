package Perl::Achievements;
# ABSTRACT: whoever die() with the most badges win

use 5.10.0;

use strict;
use warnings;

no warnings qw/ uninitialized /;

use Moose;
use MooseX::SemiAffordanceAccessor;

use Module::Pluggable
  search_path => ['Perl::Achievements::Achievement'],
  require     => 1;

use YAML::Any;
use PPI;
use File::HomeDir;
use Path::Class;
use Method::Signatures;
use DateTime::Functions;
use Data::Printer;

extends 'MooseX::App::Cmd';

with qw/ 
    MooseX::Role::Loggable
/;

sub get_config_from_file {
    my ( $class, $file ) = @_;

}

has rc => (
    is => 'ro',
    isa => 'Str',
    default => sub {
        $ENV{PERL_ACHIEVEMENTS_HOME} 
            || dir( File::HomeDir->my_home, '.perl_achievements' );
    },
    lazy => 1,
);

sub rc_file_path {
    my ( $self, @path ) = @_;

    return file( $self->rc, @path );
}


has _achievements => (
    traits => [ 'Array' ], 
    is      => 'ro',
    builder => '_achievements_builder',
    handles => {
        achievements => 'elements',
        add_achievements => 'push',
    },
);

has rc => (
    is => 'ro',
    default => sub { $ENV{HOME} . '/.perl-achievements' },
);

has ppi => (
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

#sub xrun {
#    my ( $self, @args ) = @_;

#    $self->peruse( @args );

#    exec 'perl', @args;
#}

method scan ($file) {

    $self->set_ppi( PPI::Document->new( $file ) );

    $_->scan for $self->achievements;
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

    push @checks, $_->load_or_new( app => $self ) for $self->plugins;

    return \@checks;
}

method initialize_environment {
    my $dir = $self->rc;

    die "'$dir' already exist, aborting" if -e $dir;

    mkdir $dir;
    mkdir dir( $dir, 'achievements' );
}

sub unlock_achievement {
    my ( $self, %info ) = @_;

    $self->log_debug( "achievement unlocked:\n" 
        . p( %info, colored => 0 )
    );

    $self->add_to_history( %info );
}

sub add_to_history {
    my $self = shift;
    my %info = @_;
    my $file = $self->rc_file_path( 'history' );
    open my $fh, '>>', $file;
    print {$fh} Dump \%info;
}

after unlock_achievement => sub {
    my( $self, %info ) = @_;

    say 'Congrats! You have unlocked a new achievement!';

    say '*' x 60;
    say '*** ', $info{achievement};
    say '*** level ', $info{level} if $info{level};
    say '';
    say $info{details} if $info{details};
    say '*' x 60;
};

1;
