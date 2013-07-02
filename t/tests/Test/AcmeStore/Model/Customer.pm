package Test::AcmeStore::Model::Customer;

use Test::Most;
use base 'Test::AcmeStore::Model::Base';

sub class { 'AcmeStore::Model::Customer' }

sub constructor : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'new';
    ok my $obj = $class->new( id => 100 ), '... and the constructor succeeded';
    isa_ok $obj, $class, '... and the object ';

    ok $obj = $class->new(
        id         => 100,
        first_name => 'foo',
        last_name  => 'bar',
      ),
      '... and the constructor succeeded with all params';
    isa_ok $obj, $class, '... and the object ';
}

sub schema : Tests() {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'schema';
    my $obj = $class->new( id => 100 );

    ok my $schema = $obj->schema, '... and returns schema';
    isa_ok $schema, 'AcmeStore::Schema', '... and expected schema returns';
}

sub id : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'id';
    my $obj = $class->new(
        id         => 100,
        first_name => 'foo',
        last_name  => 'bar',
    );

    is $obj->id, 100, '... and id successfully returns the expected value';

    ok $obj->id(200), '... and set the value successfully';
    is $obj->id, 200, '... and id successfully returns the expected value';
}

sub first_name : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'first_name';
    my $obj = $class->new(
        id         => 100,
        first_name => 'foo',
        last_name  => 'bar',
    );

    is $obj->first_name, 'foo',
      '... and first_name successfully returns the expected value';

    ok $obj->first_name('bar'), '... and set the value successfully';
    is $obj->first_name, 'bar',
      '... and first_name successfully returns the expected value';
}

sub last_name : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'last_name';
    my $obj = $class->new(
        id         => 100,
        first_name => 'foo',
        last_name  => 'bar',
    );

    is $obj->last_name, 'bar',
      '... and last_name successfully returns the expected value';

    ok $obj->last_name('buzz'), '... and set the value successfully';
    is $obj->last_name, 'buzz',
      '... and last_name successfully returns the expected value';
}

sub save : Tests(no_plan) {
    my $test  = shift;
    my $class = $test->class;

    can_ok $class, 'save';
    my $obj = $class->new(
        id         => 100,
        first_name => 'foo',
        last_name  => 'bar',
    );

    ok my $result = $obj->save, '... and saved successfully';
    is $result->id, 100, '... and successfully returns the value of id';

    ok $result = $obj->schema->resultset('Customer')->find(100),
      '... and found saved data successfully';
    is $result->id, 100, '... and successfully returns the value of id';
}

1;
