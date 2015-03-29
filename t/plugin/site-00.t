use Mojo::Base -strict;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Ado');
my $app = $t->app;
ok($app->plugin('site'),'site plugin loaded.');
my $class = 'Ado::Plugin::Site';
isa_ok($class, 'Ado::Plugin');
can_ok($class, 'register');

# Add meaningfull tests here...

done_testing();