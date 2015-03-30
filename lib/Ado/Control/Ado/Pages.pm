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
  my $args = Params::Check::check(
    { limit => {
        allow => sub { $_[0] =~ /^\d+$/ ? 1 : ($_[0] = 20); }
      },
      offset => {
        allow => sub { $_[0] =~ /^\d+$/ ? 1 : defined($_[0] = 0); }
      },
    },
    { limit  => $c->req->param('limit')  || 20,
      offset => $c->req->param('offset') || 0,
    }
  );

  $c->res->headers->content_range(
    "pages $$args{offset}-${\($$args{limit} + $$args{offset})}/*");
  $c->debug("rendering json and html only [$$args{limit}, $$args{offset}]");
  $c->debug('$table_class:' . $table_class);
  $c->debug('Ado::Model::Pages loaded:'
      . (exists $INC{Mojo::Util::class_to_path($table_class)}));

  #Used in template pages/list.html.ep
  $c->stash('table_class', $table_class);

  #content negotiation
  my $list = $c->list_for_json([$$args{limit}, $$args{offset}],
    [$table_class->select_range($$args{limit}, $$args{offset})]);
  return $c->respond_to(
    json => $list,
    html => {list => $list}
  );
}

# Creates a resource in table pages. A naive example.
sub create {
  my $c = shift;
  state $table_class = Ado::Model->table_to_class(%t_class_params);
  my $v = $c->validation;
  return $c->render unless $v->has_data;

  $v->required('title')->size(3, 50);
  $v->required('body')->size(3, 1 * 1024 * 1024);    #1MB
  my $res;
  eval {
    $res = $table_class->create(
      title    => $v->param('title'),
      body     => $v->param('body'),
      user_id  => $c->user->id,
      group_id => $c->user->group_id,
      deleted  => 0,

      #permissions => '-rwxr-xr-x',
    );
  } || $c->stash(error => $@);                       #very rude!!!
  $c->debug('$error:' . $c->stash('error')) if $c->stash('error');

  my $data = $res->data;

  return $c->respond_to(
    json => {data => $data},
    html => {data => $data}
  );
}

# Reads a resource from table pages. A naive example.
sub read {    ##no critic 'Subroutines::ProhibitBuiltinHomonyms'
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
Responds to HTTP methods GET and POST.
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
