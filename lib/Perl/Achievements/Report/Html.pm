package Perl::Achievements::Report::Html;

use strict;
use warnings;

use Moose;

use Method::Signatures;
use Template::Caribou::Utils;
use Template::Caribou::Tags::HTML;

with qw/ Template::Caribou Perl::Achievements::Role::Report /;

method generate {
    return $self->render( 'page' );
};

template page => sub {
    my $self = shift;
    html {
        body {
            h1 {
                $self->who . "'s Perl Achievements";
            }
        }
    }
};

1;
