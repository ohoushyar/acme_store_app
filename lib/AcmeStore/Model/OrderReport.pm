package AcmeStore::Model::OrderReport;

use Carp;
use strict;
use warnings;

use Mo;
extends 'AcmeStore::Model::Base';

sub get_all_order_numbers {
    my $self   = shift;
    my $schema = $self->schema;

    my @result;

    eval { @result = $schema->resultset('Order')->all; };
    croak("Unable to get data; ERROR[$@]") if $@;

    my @res;
    push @res, $_->order_number for @result;

    return \@res;
}

sub get_all_dates {
    my $self   = shift;
    my $schema = $self->schema;

    my @result;

    eval { @result = $schema->resultset('Order')->all; };
    croak("Unable to get data; ERROR[$@]") if $@;

    my %res;
    %res = map { '' . $_->order_date => 1 } @result;

    return \%res;

}

sub get_item_by_order {
    my $self         = shift;
    my $order_number = shift || croak 'Invlid order number';
    my $schema       = $self->schema;

    my $result;

    eval {
        $result =
          $schema->resultset('Order')
          ->search( { order_number => $order_number } );
    };
    croak("Unable to get data; ERROR[$@]") if $@;

    return $result;
}

sub get_item_by_customer {
    my $self        = shift;
    my $customer_id = shift || croak 'Invlid order number';
    my $schema      = $self->schema;

    my $result;

    eval {
        $result =
          $schema->resultset('Order')
          ->search( { customer_id => $customer_id } );
    };
    croak("Unable to get data; ERROR[$@]") if $@;

    return $result;

}

sub get_item_by_date {
    my $self       = shift;
    my $order_date = shift || croak 'Invlid order number';
    my $schema     = $self->schema;

    my $result;

    eval {
        $result =
          $schema->resultset('Order')
          ->search_literal( 'order_date - ? < 86400 AND order_date - ? >= 0',
            ( $order_date, $order_date ) );
    };
    croak("Unable to get data; ERROR[$@]") if $@;

    return $result;

}

1;

