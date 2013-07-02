package Test::AcmeStore::PosDataCSVParser;

use Test::Most;
use base 'Test::Class';

INIT { Test::Class->runtests }

sub class { 'AcmeStore::PosDataCSVParser' }

sub _get_obj {
    my $test  = shift;
    my $class = $test->class;
    my $filename = "./tmp/orders.csv";
    return $class->new(
        fullpath_filename => $filename,
    );
}

sub startup : Tests(startup => 3) {
    my $test = shift;
    die_on_fail;
    ok length $ENV{'ACMESTORE_DB'}, 'ENV set for test_db';
    use_ok $test->class;

    my $path_to_db =  $ENV{'ACMESTORE_DB'};
    ok system("sqlite3 $path_to_db < ./sql/ddl.sql") == 0,
      'created db successfully';
}

sub constructor : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $obj = $test->_get_obj,
      '... and the constructor succeeded';
    isa_ok $obj, $class, '... and the object returns as expected';

}

sub save : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'save';

    my $obj = $test->_get_obj;
    ok my $order = $obj->save, '... and successfully saved data';
}

1;
