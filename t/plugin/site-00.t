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


my $t    = Test::Mojo->new('Ado');
my $app  = $t->app;
my $dbix = $app->dbix;
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
subtest 'ado-pages' => sub {

  # request without XMLHttpRequest
  $t->get_ok('/ado-pages')->status_is(200)
    ->content_type_is('text/html;charset=UTF-8', 'html content type')
    ->element_exists('#tab_title',         'We have list title')
    ->element_exists('#tab_body',          'We have list body')
    ->element_exists('.ui.divided.list',   'We have tree list')
    ->element_exists('#create_page',       'We have #create_page form')
    ->element_exists('#p5',                'We have "politics" page')
    ->element_exists('span[data-pid="1"]', 'We have popup with "add page" menu item');

  # request with XMLHttpRequest
  $t->get_ok('/ado-pages' => {'X-Requested-With' => 'XMLHttpRequest'})->status_is(200)
    ->element_exists_not('#admin_menu', 'admin_menu is not rendered')
    ->content_like(qr|^\<\!--\sstart\sadopages\s--\>|x,
    'only right side with tree via Ajax starts')
    ->content_like(qr|\<\!--\send\sadopages\s--\>\n$|x,
    'only right side with tree via Ajax ends')
    ->element_exists('#tab_title',         'We have tab title')
    ->element_exists('#tab_body',          'We have tab body')
    ->element_exists('.ui.divided.list',   'We have tree list')
    ->element_exists('#p5',                'We have "politics" page')
    ->element_exists('span[data-pid="1"]', 'We have popup with "add page" menu item');

  # create page
  $t->post_ok(
    '/ado-pages/create/1' => {},
    form                  => {
      alias     => 'alabala',
      page_type => 'regular'
    }
  )->status_is(204);

  #check the new page
  $t->get_ok('/ado-pages' => {'X-Requested-With' => 'XMLHttpRequest'})->status_is(200)
    ->element_exists('#p8', 'New "alabala" page is created')
    ->text_is('#p8 .content', 'alabala', 'We have the expected alias');
};    #end ado-pages
ok($dbix->query('drop table pages'),   'drop pages');
ok($dbix->query('drop table domains'), 'drop domains');
ok($dbix->query('vacuum'),             'vacuum');
done_testing();
