package Test::AcmeStore::Model::Manufacturer;

use Test::Most;
use base 'Test::AcmeStore::Model::Base';

sub class { 'AcmeStore::Model::Manufacturer' }

sub _get_obj {
    my $test  = shift;
    my $class = $test->class;
    return $class->new(
        name            => 'foo',
    );
}

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

sub save : Tests(no_plan) {
    my $test   = shift;
    my $class  = $test->class;
    my $obj    = $test->_get_obj;
    my $schema = $obj->schema;

    ok my $result = $obj->save, '... and successfully saved Manufacturer';
    is $schema->resultset('Manufacturer')->find(
        {
            name            => $obj->name,
        },
        { key => 'name' },
    )->id, $result->id, '... and found the same id as result';
}

1;
