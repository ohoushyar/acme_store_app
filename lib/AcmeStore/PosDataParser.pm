package AcmeStore::PosDataParser;

use strict;
use warnings;

use Text::CSV;
use Time::Piece;
use Mo qw(build required);

use AcmeStore::Model::Base;
use AcmeStore::Model::Customer;
use AcmeStore::Model::Item;
use AcmeStore::Model::Order;
use AcmeStore::Model::Manufacturer;

has 'line' => (required => 1);
has 'data';
has 'schema';

sub BUILD {
    my $self = shift;
    my $line = $self->{'line'};
    Carp::croak 'Invalid line to parse' unless length $line;
    my $csv = Text::CSV->new();

    my ( $order_date, $customer_id, $customer_first_name, $customer_last_name,
        $order_number, $item_name, $item_manufacturer, $item_price )
      = $csv->fields() if $csv->parse( $line );
    $order_date = Time::Piece->strptime( $order_date, '%Y-%m-%d %H:%M:%S' );

    $self->data(
        {
            order_date          => $order_date,
            customer_id         => $customer_id,
            customer_first_name => $customer_first_name,
            customer_last_name  => $customer_last_name,
            order_number        => $order_number,
            item_name           => $item_name,
            item_manufacturer   => $item_manufacturer,
            item_price          => $item_price,
        }
    );

    $self->schema(AcmeStore::Model::Base->new->schema) unless defined $self->{'schema'};
}

sub save {
    my $self = shift;
    my $data = $self->data;

    my $saver = sub {
        my $schema = shift or Carp::croak 'Required to pass schema';

        my $customer = AcmeStore::Model::Customer->new(
            id         => $data->{'customer_id'},
            first_name => $data->{'customer_first_name'},
            last_name  => $data->{'customer_last_name'},
            schema => $schema,
        )->save;

        my $manufacturer = AcmeStore::Model::Manufacturer->new(
            name => $data->{'item_manufacturer'},
            schema => $schema,
        )->save;

        my $item = AcmeStore::Model::Item->new(
            name            => $data->{'item_name'},
            price           => $data->{'item_price'},
            manufacturer_id => $manufacturer->id,
            schema => $schema,
        )->save;

        my $order = AcmeStore::Model::Order->new(
            order_number => $data->{'order_number'},
            order_date   => $data->{'order_date'}->epoch,
            customer_id  => $customer->id,
            item_id      => $item->id,
            schema => $schema,
        )->save;

        return $order;
    };

    my $schema = $self->schema;

    my $res;
    eval {
        $res = $schema->txn_do($saver, ($schema));
    };
    if ($@) {
        Carp::croak "Failed to save the line into database; ERROR [$@]";
    }

    return $res;
}

1;
