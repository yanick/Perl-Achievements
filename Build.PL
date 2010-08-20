
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Carp' => '0',
    'Module::Build' => '0.3601',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'perl' => '5.004'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'whoever die() with the most badges win',
  'dist_author' => [
    'Yanick Champoux <yanick@cpan.org>'
  ],
  'dist_name' => 'Perl-Achievements',
  'dist_version' => '0.0.1',
  'license' => 'perl',
  'module_name' => 'Perl::Achievements',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'DateTime' => '0',
    'Getopt::Long' => '0',
    'List::MoreUtils' => '0',
    'Module::Pluggable' => '0',
    'Moose' => '0',
    'Moose::Role' => '0',
    'MooseX::Storage' => '0',
    'MooseX::Types::DateTime' => '0',
    'PPI' => '0',
    'YAML::Any' => '0'
  },
  'script_files' => [
    'scripts/perl-achievements'
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
