package Ado::Model::Pages; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Ado::Model);

sub is_base_class{return 0}
my $TABLE_NAME = 'pages';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'pid',
             'domain_id',
             'alias',
             'page_type',
             'sorting',
             'template',
             'cache',
             'expiry',
             'permissions',
             'user_id',
             'group_id',
             'tstamp',
             'start',
             'stop',
             'published',
             'hidden',
             'deleted',
             'changed_by'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'expiry' => {
                          'required' => 1,
                          'allow' => qr/(?^x:^-?\d{1,11}$)/,
                          'defined' => 1,
                          'default' => '86400'
                        },
            'user_id' => {
                           'allow' => qr/(?^x:^-?\d{1,11}$)/
                         },
            'id' => {
                      'allow' => qr/(?^x:^-?\d{1,}$)/,
                      'required' => 1,
                      'defined' => 1
                    },
            'published' => {
                             'required' => 1,
                             'allow' => qr/(?^x:^-?\d{1,1}$)/,
                             'defined' => 1,
                             'default' => '0'
                           },
            'stop' => {
                        'default' => '0',
                        'allow' => qr/(?^x:^-?\d{1,11}$)/,
                        'required' => 1,
                        'defined' => 1
                      },
            'pid' => {
                       'default' => '0',
                       'defined' => 1,
                       'allow' => qr/(?^x:^-?\d{1,11}$)/,
                       'required' => 1
                     },
            'page_type' => {
                             'allow' => sub { "DUMMY" },
                             'required' => 1,
                             'defined' => 1
                           },
            'cache' => {
                         'allow' => qr/(?^x:^-?\d{1,1}$)/,
                         'defined' => 1,
                         'required' => 1,
                         'default' => '0'
                       },
            'alias' => {
                         'default' => '',
                         'defined' => 1,
                         'allow' => sub { "DUMMY" },
                         'required' => 1
                       },
            'permissions' => {
                               'default' => '-rwxr-xr-xr',
                               'allow' => sub { "DUMMY" },
                               'defined' => 1,
                               'required' => 1
                             },
            'changed_by' => {
                              'allow' => qr/(?^x:^-?\d{1,11}$)/,
                              'required' => 1,
                              'defined' => 1
                            },
            'sorting' => {
                           'allow' => qr/(?^x:^-?\d{1,11}$)/,
                           'required' => 1,
                           'defined' => 1,
                           'default' => '1'
                         },
            'tstamp' => {
                          'allow' => qr/(?^x:^-?\d{1,11}$)/,
                          'defined' => 1,
                          'required' => 1,
                          'default' => '0'
                        },
            'hidden' => {
                          'default' => '1',
                          'required' => 1,
                          'allow' => qr/(?^x:^-?\d{1,1}$)/,
                          'defined' => 1
                        },
            'start' => {
                         'default' => '0',
                         'allow' => qr/(?^x:^-?\d{1,11}$)/,
                         'defined' => 1,
                         'required' => 1
                       },
            'group_id' => {
                            'default' => '1',
                            'allow' => qr/(?^x:^-?\d{1,11}$)/
                          },
            'deleted' => {
                           'default' => '0',
                           'required' => 1,
                           'allow' => qr/(?^x:^-?\d{1,4}$)/,
                           'defined' => 1
                         },
            'domain_id' => {
                             'allow' => qr/(?^x:^-?\d{1,11}$)/,
                             'defined' => 1,
                             'required' => 1,
                             'default' => '0'
                           },
            'template' => {
                            'allow' => sub { "DUMMY" }
                          }
          };

sub CHECKS {return $CHECKS}

__PACKAGE__->QUOTE_IDENTIFIERS(0);
#__PACKAGE__->BUILD;#build accessors during load

1;

=pod

=encoding utf8

=head1 NAME

A class for TABLE pages in schema main

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<pages> has an accessor method in this class.

=head2 id

=head2 pid

=head2 domain_id

=head2 alias

=head2 page_type

=head2 sorting

=head2 template

=head2 cache

=head2 expiry

=head2 permissions

=head2 user_id

=head2 group_id

=head2 tstamp

=head2 start

=head2 stop

=head2 published

=head2 hidden

=head2 deleted

=head2 changed_by

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Ado::Model>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

berov

=cut
