use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('AcmeStoreApp');
$t->get_ok('/')->status_is(200)->content_like(qr/ACME Store/i);

done_testing();
