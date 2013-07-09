package Test::AcmeStore::Model::Base;

use Test::Most;
use base 'Test::Class';

INIT { Test::Class->runtests }

sub class { 'AcmeStore::Model::Base' }

sub startup : Tests(startup => 3) {
    my $test = shift;
    die_on_fail;
    ok length $ENV{'ACMESTORE_DB'}, 'ACMESTORE_DB ENV variable set for test_db';
    use_ok $test->class;

    my $path_to_db =  $ENV{'ACMESTORE_DB'};
    ok system("sqlite3 $path_to_db < ./sql/ddl.sql") == 0,
      'created db successfully';
}

sub constructor : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $base_obj = $class->new, '... and the constructor succeeded';
    isa_ok $base_obj, $class, '... and the object returns as expected';
}

sub schema : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'schema';
    my $base_obj = $class->new;

    ok my $schema = $base_obj->schema, '... and returns schema';
    isa_ok $schema, 'AcmeStore::Schema', '... and expected schema returns';

}

1;
