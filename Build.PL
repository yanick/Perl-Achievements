
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Carp" => 0,
    "Module::Build" => "0.3601",
    "Scalar::Util" => 0,
    "Test::More" => "0.94"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "whoever die()s with the most badges win",
  "dist_author" => [
    "Yanick Champoux <yanick\@cpan.org>"
  ],
  "dist_name" => "Perl-Achievements",
  "dist_version" => "0.0.2",
  "license" => "perl",
  "module_name" => "Perl::Achievements",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Data::Printer" => 0,
    "DateTime::Functions" => 0,
    "Digest::SHA" => 0,
    "File::HomeDir" => 0,
    "File::Touch" => 0,
    "List::MoreUtils" => 0,
    "Method::Signatures" => 0,
    "Module::Pluggable" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "MooseX::App::Cmd" => 0,
    "MooseX::App::Cmd::Command" => 0,
    "MooseX::ConfigFromFile" => 0,
    "MooseX::Role::Loggable" => 0,
    "MooseX::SemiAffordanceAccessor" => 0,
    "PPI" => 0,
    "Path::Class" => 0,
    "YAML::Any" => 0,
    "perl" => "5.10.0",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
