package Test::AcmeStore::PosDataParser;

use Test::Most;
use base 'Test::Class';

INIT { Test::Class->runtests }

sub class { 'AcmeStore::PosDataParser' }

sub _get_obj {
    my $test  = shift;
    my $class = $test->class;
    my $line =
      '2013-02-01 12:32:00,7,Publius,Ovidius,23,fountain pen,acme,$3.25';
    return $class->new( line => $line );
}

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

sub constructor : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $obj = $test->_get_obj,
      '... and the constructor succeeded';
    isa_ok $obj, $class, '... and the object returns as expected';

    my $data = $obj->data;
    isa_ok $data, 'HASH', '... and data successfully extracted and';
    ok defined $data->{'order_date'}, '... and order_date is defined';
    isa_ok $data->{'order_date'}, 'Time::Piece', '... and order_date';
    is $data->{'order_date'}->epoch, 1359721920,
      '... and epoch value is correct';
    is $data->{'customer_id'}, 7, '... and customer_id successfully set';
    is $data->{'customer_first_name'}, 'Publius',
      '... and customer_first_name successfully set';
    is $data->{'customer_last_name'}, 'Ovidius',
      '... and customer_last_name successfully set';
    is $data->{'order_number'}, 23, '... and order_number successfully set';
    is $data->{'item_name'}, 'fountain pen',
      '... and item_name successfully set';
    is $data->{'item_manufacturer'}, 'acme',
      '... and item_manufacturer successfully set';
    is $data->{'item_price'}, '$3.25', '... and item_price successfully set';


    my $special_case = q(2013-02-05 19:23:04,19,John,Davidson,53-1,"pen, ball point",acme,$.99);
    ok my $obj2 = $class->new( line => $special_case),
      'The constructor succeeded on special case';
    isa_ok $obj2, $class, '... and the object returns as expected';
    is $obj2->data->{'item_name'}, 'pen, ball point',
      '... and item_name successfully set';

}

sub save : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'save';

    my $obj = $test->_get_obj;
    ok my $order = $obj->save, '... and successfully saved data';
    isa_ok $order, 'AcmeStore::Schema::Result::Order', '... and order';

    is $order->customer->first_name, 'Publius', '... and successfully got the value of customer from order';
    is $order->item->manufacturer->name, 'acme', '... and successfully got the value of manufacturer of order';
}

1;
