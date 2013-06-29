package Test::AcmeStore::Model::Order;

use DateTime;
use Test::Most;
use base 'Test::AcmeStore::Model::Base';

sub class { 'AcmeStore::Model::Order' }

sub _get_obj {
    my $test  = shift;
    my $class = $test->class;
    return $class->new(
        order_number => '12-3',
        order_date   => 1372536222,
        customer_id  => 10,
        item_id      => 20,
    );
}

sub make_fixture : Test(setup) {
    my $test   = shift;
    my $class  = $test->class;
    my $schema = AcmeStore::Model::Base->new->schema;

    ok my $man_id =
      $schema->resultset('Manufacturer')->create( { name => 'foo' } )->id,
      '... added manufacturer fixture';
    ok AcmeStore::Model::Customer->new(
        id         => 100,
        first_name => 'foo',
        last_name  => 'bar',
    )->save, '... added customer fixture';
    ok AcmeStore::Model::Item->new(
        name            => 'foofoo',
        price           => '$10',
        manufacturer_id => $man_id,
    )->save, '... added item fixture';
};

sub constructor : Tests(3) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $obj = $test->_get_obj, '... and the constructor succeeded';
    isa_ok $obj, $class, '... and the object ';
}

sub schema : Tests() {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'schema';
    my $obj = $test->_get_obj;

    ok my $schema = $obj->schema, '... and returns schema';
    isa_ok $schema, 'AcmeStore::Schema', '... and expected schema returns';
}

sub order_number : Tests(4) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'order_number';
    my $obj = $test->_get_obj;

    is $obj->order_number, '12-3',
      '... and order_number successfully returns the expected value';

    ok $obj->order_number('12-34'), '... and set the value successfully';
    is $obj->order_number, '12-34',
      '... and order_number successfully returns the expected value';
}

sub order_date : Tests(4) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'order_date';
    my $obj = $test->_get_obj;

    is $obj->order_date, 1372536222,
      '... and order_date successfully returns the expected value';

    my $now = time;
    ok $obj->order_date($now), '... and set the value successfully';
    is $obj->order_date, $now,
      '... and order_date successfully returns the expected value';
}

sub customer_id : Tests(4) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'customer_id';
    my $obj = $test->_get_obj;

    is $obj->customer_id, 10,
      '... and customer_id successfully returns the expected value';

    ok $obj->customer_id(200), '... and set the value successfully';
    is $obj->customer_id, 200,
      '... and customer_id successfully returns the expected value';
}

sub save : Tests(no_plan) {
    my $test   = shift;
    my $class  = $test->class;
    my $obj    = $test->_get_obj;
    my $schema = $obj->schema;

    ok my $cid = $schema->resultset('Customer')->first->id,
      '... successfully get customer_id';
    $obj->customer_id($cid);
    ok my $iid = $schema->resultset('Item')->first->id,
      '... successfully get item_id';
    $obj->customer_id($iid);

    ok my $result = $obj->save, '... and successfully saved Order';
    is $schema->resultset('Order')->find(
        {
            order_number => $obj->order_number,
            order_date   => $obj->order_date,
            customer_id  => $obj->customer_id,
            item_id      => $obj->item_id,
        },
        { key => 'number_date_cid_iid' },
    )->id, $result->id, '... and found the same id as result';
}

1;
