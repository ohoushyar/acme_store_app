package AcmeStore::Model::Order;

use strict;
use warnings;

use Mo qw(default required);
extends 'AcmeStore::Model::Base';

has 'order_number' => (is => 'rw', required => 1);
has 'order_date' => (is => 'rw', required => 1);
has 'customer_id' => (is => 'rw', required => 1);
has 'item_id' => (is => 'rw', required => 1);

sub save {
    my $self = shift;
    my $schema = $self->schema;
    my $result;

    #$schema->storage->debug(1);
    eval {
        $result = $schema->resultset('Order')->find_or_create(
            {
                order_number => $self->order_number,
                order_date => $self->order_date,
                customer_id => $self->customer_id,
                item_id => $self->item_id,
            },
            { key => 'number_date_cid_iid' },
        );
    };
    if ($@) {
        Carp::croak("Unable to save Order; ERROR: [$@]");
        return;
    }

    return $result;
}

1;


