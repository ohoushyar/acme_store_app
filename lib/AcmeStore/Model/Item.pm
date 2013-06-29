package AcmeStore::Model::Item;

use strict;
use warnings;

use Mo qw(default required);
extends 'AcmeStore::Model::Base';

has 'name' => (is => 'rw', required => 1);
has 'price' => (is => 'rw', required => 1);
has 'manufacturer_id' => (is => 'rw', required => 1);

sub save {
    my $self = shift;
    my $schema = $self->schema;
    my $result;

    #$schema->storage->debug(1);
    eval {
        $result = $schema->resultset('Item')->find_or_create(
            {
                name => $self->name,
                price => $self->price,
                manufacturer_id => $self->manufacturer_id,
            },
            { key => 'name_price_manufacturer' },
        );
    };
    if ($@) {
        Carp::croak("Unable to save Item; ERROR: [$@]");
        return;
    }

    return $result;
}

1;


