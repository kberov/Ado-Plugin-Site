package Ado::Control::Ado::Pages;
use Mojo::Base 'Ado::Control::Ado';

#Parameters to generate a model class on the fly
my %t_class_params = (
  namespace => 'Ado::Model',
  table     => 'pages',
  type      => 'TABLE'
);

# List resourses from table pages.
sub list {
  my $c = shift;
  state $table_class = Ado::Model->table_to_class(%t_class_params);
  $c->require_formats('json', 'html') || return;

  #Todo: guess page by looking  for accessible by this user root pages
  my $id = $c->req->param('id') // '';
  $id = 1 unless ($id =~ m/^\d+$/);

  #Used in template pages/list.html.ep
  $c->stash(table_class => $table_class, title => $c->l('Pages'));
  my $root_page = $table_class->find($id);

  #content negotiation
  return $c->respond_to(
    json => {
      root_page => $root_page->data,    #think about JSON responses later
    },
    html => {root_page => $root_page}
  );
}


# Creates a resource in table pages. A naive example.
sub create {
  my $c = shift;
  state $table_class         = Ado::Model->table_to_class(%t_class_params);
  state $validation_template = {
    alias     => {required => 1, size => [3, 50]},
    page_type => {in       => [qw(regular folder)]},
  };

  my $vresult = $c->validate_input($validation_template);

  #400 Bad Request
  if ($vresult->{errors}) {
    $c->app->log->error('Validation error:' . $c->dumper($vresult));
    return $c->render(
      status => $vresult->{json}{code},
      json   => $vresult->{json}
    );
  }

  my $user = $c->user;
  my $res;
  eval {
    $res = $table_class->create(
      pid         => $c->stash('pid'),
      domain_id   => 1,                               #now only one domain we have
      alias       => $vresult->{output}{alias},
      page_type   => $vresult->{output}{page_type},
      user_id     => $user->id,
      group_id    => $user->group_id,
      changed_by  => $user->id,
      deleted     => 0,
      tstamp      => time,
      hidden      => 0,
      permissions => '-rwxr-xr-xr',
    );
  } || $c->stash(error => $@);    #very rude!!!
  if ($c->stash('error')) {
    $c->app->log->error('$error:' . $c->stash('error'));
    return $c->render(
      status => 500,
      json   => {message => 'Internal Server Error!'}
    );
  }

  return $c->respond_to(
    json => {status => 204},
    html => {status => 204}       #todo
  );
}

# Reads a resource from table pages. A naive example.
sub read {                        ##no critic 'Subroutines::ProhibitBuiltinHomonyms'
  my $c = shift;
  state $table_class = Ado::Model->table_to_class(%t_class_params);

  #This could be validated by a stricter route
  my ($id) = $c->stash('id') =~ /(\d+)/;

  my $data = $table_class->find($id)->data;
  $c->debug('$data:' . $c->dumper($data));
  return $c->respond_to(
    json => {article => $data},
    html => {article => $data}
  );
}

# Updates a resource in table pages.
sub update {
  my $c = shift;
  state $table_class = Ado::Model->table_to_class(
    namespace => 'Ado::Model',
    table     => 'pages',
    type      => 'TABLE'
  );
  my $v    = $c->validation;
  my ($id) = $c->stash('id') =~ /(\d+)/;
  my $res  = $table_class->find($id);
  $c->reply->not_found() unless $res->data;
  $c->debug('$data:' . $c->dumper($res->data));

  if ($v->has_data && $res->data) {
    $v->optional('title')->size(3, 50);
    $v->optional('body')->size(3, 1 * 1024 * 1024);    #1MB
    $res->title($v->param('title'))->body($v->param('body'))->update()
      unless $v->has_error;
  }
  my $data = $res->data;
  return $c->respond_to(
    json => {article => $data},
    html => {article => $data}
  );
}

# "Deletes" a resource from table pages.
sub delete {    ##no critic 'Subroutines::ProhibitBuiltinHomonyms'
  return shift->render(message => '"delete" is not implemented...');
}


1;

__END__

=encoding utf8

=head1 NAME

Ado::Control::Ado::Pages - a controller for resource /ado-pages.

=head1 SYNOPSIS


  # Start Ado!
  #in your browser go to
  http://your-host/ado-pages/list
  #or
  http://your-host/ado-pages
  #and
  http://your-host/ado-pages/update/$id
  #and
  http://your-host/ado-pages/create


=head1 ATTRIBUTES

L<Ado::Control::Ado::Pages> inherits all the attributes from
L<Ado::Control::Ado>.

=head1 METHODS/ACTIONS

L<Ado::Control::Ado::Pages> inherits all methods from
L<Ado::Control::Ado> and implements the following new ones.
   


=head2 create

Handles route C</ado-pages/create>.
Responds to HTTP method POST only (for now).
Supported MIME types are 'application/json' and 'text/html'.

=head2 list

Handles route C</ado-pages> and C</ado-pages-list>.
Responds to HTTP method GET.
Supported MIME types are 'application/json' and 'text/html'.

=head2 read

Handles route C</ado-pages/read/:id>.
Responds to HTTP method GET.
Supported MIME types are 'application/json' and 'text/html'.

=head2 update

Handles route C</ado-pages/update/:id>.
Responds to HTTP methods GET and PUT.
Supported MIME types are 'application/json' and 'text/html'.

=head2 delete

Handles route C</ado-pages/delete/:id>.
Responds to HTTP method GET and DELETE.
Supported MIME types are 'application/json' and 'text/html'.

=head1 SEE ALSO

L<Ado::Control::Ado::Domains>, L<Ado::Control::Ado>, L<Ado::Control>

=head1 AUTHOR

Красимир Беров (Krasimir Berov)

=head1 COPYRIGHT AND LICENSE

Copyright 2015 Красимир Беров (Krasimir Berov).

This program is free software, you can redistribute it and/or
modify it under the terms of the
GNU Lesser General Public License v3 (LGPL-3.0).
You may copy, distribute and modify the software provided that
modifications are open source. However, software that includes
the license may release under a different license.

See http://opensource.org/licenses/lgpl-3.0.html for more information.


=cut
