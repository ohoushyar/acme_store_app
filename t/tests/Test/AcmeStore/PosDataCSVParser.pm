package Test::AcmeStore::PosDataCSVParser;

use FindBin;
use Test::Most;
use base 'Test::Class';

use constant DBFILE => './tmp/test_db';

INIT { Test::Class->runtests }

sub class { 'AcmeStore::PosDataCSVParser' }

sub _get_obj {
    my $test  = shift;
    my $class = $test->class;
    my $filename = "$FindBin::Bin/../../../../tmp/orders.csv";
    return $class->new(
        fullpath_filename => $filename,
    );
}

sub startup : Tests(startup => 2) {
    my $test = shift;

    use_ok $test->class;

    my $path_to_db = DBFILE;
    system('mkdir ./tmp') == 0
      or die 'Unable to make dir ./tmp'
      unless ( -d './tmp' );
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
