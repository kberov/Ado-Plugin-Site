use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use File::Spec::Functions qw(splitdir catdir catfile);
use File::Basename;
use Cwd qw(abs_path);


#use our own ado.conf
$ENV{MOJO_HOME} = abs_path dirname(__FILE__);
$ENV{MOJO_CONFIG} = catfile($ENV{MOJO_HOME}, 'ado.conf');

# Make sure the database file is writable!
chmod(oct('0600'), catfile($ENV{MOJO_HOME}, 'ado_site.sqlite'))
  or plan skip_all => 'ado_site.sqlite cannot be made writable!';


my $t   = Test::Mojo->new('Ado');
my $app = $t->app;
ok($app->plugin('site'), 'site plugin loaded.');
my $class = 'Ado::Plugin::Site';
isa_ok($class, 'Ado::Plugin');

subtest run_plugin_with_own_ado_config_and_database => sub {

#first we need to login!!!
  my $login_url =
    $t->get_ok('/ado')->status_is(302)->header_like('Location' => qr|/login$|)
    ->tx->res->headers->header('Location');

  $t->get_ok('/login/ado');
  my $form           = $t->tx->res->dom->at('#login_form');
  my $new_csrf_token = $form->at('[name="csrf_token"]')->{value};

  $t->post_ok(
    $login_url => {},
    form       => {
      _method        => 'login/ado',
      login_name     => 'test1',
      login_password => '',
      csrf_token     => $new_csrf_token,
      digest =>
        Mojo::Util::sha1_hex($new_csrf_token . Mojo::Util::sha1_hex('test1' . 'test1')),
      }

      #redirect back to the $c->session('over_route')
  )->status_is(302)->header_is('Location' => '/ado');

# default ado page
  $t->get_ok('/ado')->status_is(200)
    ->content_like(qr/Controller: ado-default; Action: index/)
    ->element_exists('#admin_menu [href="/ado-domains"]',
    '/ado-domains is in admin_menu')
    ->element_exists('#admin_menu [href="/ado-pages"]', '/ado-pages is in admin_menu');


};    #end run_plugin_with_own_ado_config_and_database


done_testing();
