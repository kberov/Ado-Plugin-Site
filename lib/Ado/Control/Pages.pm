package Ado::Control::Pages;
use Mojo::Base 'Ado::Control';

our $VERSION = '0.01';

# Generate class on the fly from the database.
# No worries - this is cheap, one-time generation.
# See documentation for Ado::Model::class_from_table
my $table_class = Ado::Model->table_to_class(
  namespace => 'Ado::Model',
  table     => 'pages',
  type      => 'TABLE'
);

# List resourses from table pages.
sub list {
    my $c = shift;
    $c->require_formats('json','html') || return;
    my $args = Params::Check::check(
        {   limit => {
                allow => sub { $_[0] =~ /^\d+$/ ? 1 : ($_[0] = 20); }
            },
            offset => {
                allow => sub { $_[0] =~ /^\d+$/ ? 1 : defined($_[0] = 0); }
            },
        },
        {   limit  => $c->req->param('limit')  || 20,
            offset => $c->req->param('offset') || 0,
        }
    );

    $c->res->headers->content_range(
        "pages $$args{offset}-${\($$args{limit} + $$args{offset})}/*");
    $c->debug("rendering json and html only [$$args{limit}, $$args{offset}]");

    #Used in template pages/list.html.ep
    $c->stash('table_class',$table_class);
    #content negotiation
    my $list = $c->list_for_json(
            [$$args{limit}, $$args{offset}],
            [$table_class->select_range($$args{limit}, $$args{offset})]
        );
    return $c->respond_to(
        json => $list,
        html =>{list =>$list}
    );
}

# Creates a resource in table pages. A naive example.  
sub create {
    my $c = shift;
    my $v = $c->validation;
    return $c->render unless $v->has_data;
    
    $v->required('title')->size(3, 50);
    $v->required('body')->size(3, 1 * 1024 * 1024);#1MB
    my $res;
    eval {
      $res = $table_class->create(
        title     => $v->param('title'),
        body      => $v->param('body'),
        user_id   => $c->user->id,
        group_id  => $c->user->group_id,
        deleted   => 0,
        #permissions => '-rwxr-xr-x',
        );
    }||$c->stash(error=>$@);#very rude!!!
        $c->debug('$error:'.$c->stash('error')) if $c->stash('error');

    my $data = $res->data;

    return $c->respond_to(
        json => {data => $data},
        html => {data => $data}
    );
}

# Reads a resource from table pages. A naive example.
sub read {
    my $c = shift;
    #This could be validated by a stricter route
    my ($id) = $c->stash('id') =~/(\d+)/;

    my $data = $table_class->find($id)->data;
    $c->debug('$data:'.$c->dumper($data));
    return $c->respond_to(
        json => {article => $data},
        html => {article => $data}
    );
}

# Updates a resource in table pages.  
sub update {
    my $c = shift;
    my $v = $c->validation;
    my ($id) = $c->stash('id') =~/(\d+)/;
    my $res = $table_class->find($id);
    $c->reply->not_found() unless $res->data;
    $c->debug('$data:'.$c->dumper($res->data));
    
    if($v->has_data && $res->data){
        $v->optional('title')->size(3, 50);
        $v->optional('body')->size(3, 1 * 1024 * 1024);#1MB
        $res->title($v->param('title'))->body($v->param('body'))
         ->update() unless $v->has_error;
    }
    my $data = $res->data;
    return $c->respond_to(
        json => {article => $data},
        html => {article => $data}
    );
}

# "Deletes" a resource from table pages.  
sub delete {
    return shift->render(message => '"delete" is not implemented...');
}



1;

__END__

=encoding utf8

=head1 NAME

Ado::Control::Pages - a controller for resource pages.

=head1 SYNOPSIS







=cut
