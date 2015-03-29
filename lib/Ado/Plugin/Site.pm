package Ado::Plugin::Site;
use Mojo::Base 'Ado::Plugin';
our $VERSION = '0.01';

sub register {
  my ($self, $app, $config) = shift->initialise(@_);
  $self->_amend_admin_menu();
  return $self;
}

# Add menu items to the Admin menu in the Administration UI
sub _amend_admin_menu {
  my $self          = shift;
  my $menu          = $self->app->admin_menu;
  my $content_items = $menu->items->first(sub { $_[0]->title eq 'Content' })->items;
  unshift @$content_items,
    Ado::UI::Menu->new(title => 'Domains', icon => 'world', url => '/ado-domains');
  return 1;
}

1;

__END__

=encoding utf8

=head1 NAME

Ado::Plugin::Site - Manage your Sites.

=head1 SYNOPSIS

  # in $ENV{MOJO_HOME}/etc/ado.config
  plugins => {
    # other plugins here...
    'admin'
    'site',
    # other plugins here...
  }

   # GO to http://your-domain/ado
   # Access /ado-domains and ado-sites from the main admin menu

=head1 DESCRIPTION

L<Ado::Plugin::Site> is an L<Ado> plugin that helps you to manage your domains
and sites in the control panel provided by L<Ado::Plugin::Admin>.

=head1 METHODS

L<Ado::Plugin::Site> inherits all methods from
L<Ado::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Ado->new);

Register plugin in L<Ado> application.

=head1 SEE ALSO

L<Ado::Plugin::Admin>,
L<Ado::Control::Ado::Domains>, L<Ado::Control::Ado::Pages>
L<Ado::Plugin>, L<Mojolicious::Guides::Growing>,
L<Ado::Manual>, L<Mojolicious>,  L<http://mojolicio.us>.

=head1 AUTHOR

Your Name

=head1 COPYRIGHT AND LICENSE

Copyright 2015 Your Name.

This program is free software, you can redistribute it and/or
modify it under the terms of the 
GNU Lesser General Public License v3 (LGPL-3.0).
You may copy, distribute and modify the software provided that 
modifications are open source. However, software that includes 
the license may release under a different license.

See http://opensource.org/licenses/lgpl-3.0.html for more information.

=cut
