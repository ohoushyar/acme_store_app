package Test::AcmeStore::Model::Item;

use Test::Most;
use base 'Test::AcmeStore::Model::Base';

use AcmeStore::Model::Manufacturer;

sub class { 'AcmeStore::Model::Item' }

sub _get_obj {
    my $test  = shift;
    my $class = $test->class;
    return $class->new(
        name            => 'foo',
        price           => '$10',
        manufacturer_id => 100,
    );
}

sub make_fixture : Test(setup => 1) {
    my $test   = shift;
    my $class  = $test->class;

    ok my $res = AcmeStore::Model::Manufacturer->new(name => 'foo')->save,
      '... added fixture successfully';
};

sub constructor : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $obj = $test->_get_obj, '... and the constructor succeeded';
    isa_ok $obj, $class, '... and the object ';
}

sub schema : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'schema';
    my $obj = $test->_get_obj;

    ok my $schema = $obj->schema, '... and returns schema';
    isa_ok $schema, 'AcmeStore::Schema', '... and expected schema returns';
}

sub name : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'name';
    my $obj = $test->_get_obj;

    is $obj->name, 'foo',
      '... and name successfully returns the expected value';

    ok $obj->name('bar'), '... and set the value successfully';
    is $obj->name, 'bar',
      '... and name successfully returns the expected value';
}

sub price : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'price';
    my $obj = $test->_get_obj;

    is $obj->price, '$10',
      '... and price successfully returns the expected value';

    ok $obj->price('$20'), '... and set the value successfully';
    is $obj->price, '$20',
      '... and price successfully returns the expected value';
}

sub manufacturer_id : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'manufacturer_id';
    my $obj = $test->_get_obj;

    is $obj->manufacturer_id, 100,
      '... and manufacturer_id successfully returns the expected value';

    ok $obj->manufacturer_id(200), '... and set the value successfully';
    is $obj->manufacturer_id, 200,
      '... and manufacturer_id successfully returns the expected value';
}

sub save : Tests(no_plan) {
    my $test   = shift;
    my $class  = $test->class;
    my $obj    = $test->_get_obj;
    my $schema = $obj->schema;

    ok my $man_id = $schema->resultset('Manufacturer')->first->id,
      '... successfully get manufacturer_id';
    $obj->manufacturer_id($man_id);

    ok my $result = $obj->save, '... and successfully saved item';
    is $schema->resultset('Item')->find(
        {
            name            => $obj->name,
            price           => $obj->price,
            manufacturer_id => $obj->manufacturer_id,
        },
        { key => 'name_price_manufacturer' },
    )->id, $result->id, '... and found the same id as result';
}

1;
