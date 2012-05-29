package Perl::Achievements::Achievement::SchwartzianTransform;
# ABSTRACT: A new achievement!
use strict;
use warnings;
use Moose;
use MooseX::SemiAffordanceAccessor;
with 'Perl::Achievements::Achievement';
has transformations => (
    traits  => [qw/ Counter Perl::Achievements::Role::ConfigItem /],
    isa     => 'Num',
    is      => 'rw',
    default => 0,
    # lazy_build => 1,  # it would be nice to have the computation below in _build_transformations but it won't keep the value?!
    handles => {
        inc_transformations => 'inc',
    },
);
sub scan {
    my $self = shift;
    use List::MoreUtils 'uniq';
    # Living up to the name of...
    my $schwartzian_transformations =
      scalar                                                                                # Step 6) Superfluous but still nice to have a step 6 ;-)
      grep { /map.*?sort.*?map/g }                                                          # Step 5) DIRRRTY! (but matches more complex statements than just a simple map sort map)
      map {                                                                                 # Step 4) Prune the statements gathered from Step 3)
        $_->prune(sub {                                                                     #   (that is, remove everything from that statement)
                    !(                                                                      #   except
                            $_[1]->isa('PPI::Token::Word')                                  #   the tokens
                        and $_[1]->literal ~~ [ 'map', 'grep', 'sort' ]                     #   'map' and 'sort' ('grep' doesn't hurt here and you could
                    )                                                                       #   do some clever combination of Steps 1 + 4 + 5....
            }                                                                               #   Finally,
          ) => $_->content                                                                  #   don't forget to return the content
      }                                                                                     #   (since prune only returns the number it has pruned)
      uniq                                                                                  # Step 3) uniq-ify them
      map { $_->statement }                                                                 # Step 2) Get the statements in which these tokens occur
      @{                                                                                    # Step 1) Generate the list to work on...
        $self->ppi->find(                                                                   #   all places where 'map' or 'sort' occurs
            sub {                                                                           #   of course...
                      $_[1]->isa('PPI::Token::Word')                                        #   you could watch out for more
                  and $_[1]->literal ~~ [ 'map', 'grep' ]                                   #   , 'sort', 'uniq'
            }
        )
      };
    $self->inc_transformations($schwartzian_transformations // 0);
    return unless $self->transformations >= 1** $self->level;
    $self->inc_level;
    $self->unlock(
        sprintf "Nice one! You have used %d schwartzian transformations all in all throughout your scans",
                $self->transformations
    );
}
1;