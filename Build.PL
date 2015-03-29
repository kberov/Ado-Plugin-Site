use 5.014;
use strict;
use warnings FATAL => 'all';
use Ado::BuildPlugin;

my $builder = Ado::BuildPlugin->new(
  module_name        => 'Ado::Plugin::Site',
  license            => 'lgpl_3_0',
  dist_version_from  => 'lib/Ado/Plugin/Site.pm',
  create_readme      => 1,
  dist_author        => q{Krasimir Berov <berov@cpan.org>},
  configure_requires => {'Module::Build' => 0.42, Ado => 0},
  build_requires => {'Test::More' => 0},
  requires       => {
    Ado                  => '0.86',
    'Ado::Plugin::Admin' => '0.12'
  },
  recursive_test_files => 1,
  meta_merge           => {
    resources => {
      repository => "https://github.com/kberov/Ado-Plugin-Site",
      bugtracker => "https://github.com/kberov/Ado-Plugin-Site/issues",
    },
    keywords =>
      [qw/Ado::Plugin::Site Mojolicious realtime web ERP REST CMS enterprise/],
    no_index => {namespace => ['Ado::Model'],}
  },
  add_to_cleanup => ['Ado-Plugin-Site-*', '*.bak'],
);

$builder->create_build_script();
