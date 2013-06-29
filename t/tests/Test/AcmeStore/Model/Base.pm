package Test::AcmeStore::Model::Base;

use Test::Most;
use base 'Test::Class';

sub class { 'AcmeStore::Model::Base' }

sub startup : Tests(startup => 2) {
    my $test = shift;

    use_ok $test->class;

    my $path_to_db = './tmp/test_db';
    system('mkdir ./tmp') == 0
      or die 'Unable to make dir ./tmp'
      unless ( -d './tmp' );
    ok system("sqlite3 $path_to_db < ./sql/ddl.sql") == 0,
      'created db successfully';
}

sub constructor : Tests(3) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $base_obj = $class->new, '... and the constructor succeeded';
    isa_ok $base_obj, $class, '... and the object returns as expected';
}

sub schema : Tests() {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'schema';
    my $base_obj = $class->new;

    ok my $schema = $base_obj->schema, '... and returns schema';
    isa_ok $schema, 'AcmeStore::Schema', '... and expected schema returns';

}

1;
