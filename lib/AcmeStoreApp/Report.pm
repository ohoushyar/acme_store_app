package AcmeStoreApp::Report;
use DateTime;
use Mojo::Base 'Mojolicious::Controller';
use AcmeStore::Model::OrderReport;
use AcmeStore::Model::CustomerReport;

sub report {
    my $self   = shift;
    my $logger = $self->app->log;

    my $order_report    = AcmeStore::Model::OrderReport->new;
    my $customer_report = AcmeStore::Model::CustomerReport->new;
    my $res             = $order_report->get_all_dates;
    my @keys_of_res     = map {$self->_get_date_epoch($_)} keys %$res;

    $self->stash( order_numbers => $order_report->get_all_order_numbers );
    $self->stash( customers     => $customer_report->get_all_customers );
    $self->stash( order_dates   => \@keys_of_res );

};

sub _get_date_epoch {
    my $self = shift;
    my $epoch = shift;
    my $logger = $self->app->log;

    #$logger->debug("old epoch [$epoch]");
    my $dt = DateTime->from_epoch(epoch => $epoch);
    my $new_dt = DateTime->new( year => $dt->year, month => $dt->month, day => $dt->day );
    my $new_epoch = $new_dt->epoch;
    #$logger->debug("new epoch [$new_epoch]");

    return $new_dt->epoch;
}

# This action will render a template
sub show_report {
    my $self         = shift;
    my $logger       = $self->app->log;
    my $order_report = AcmeStore::Model::OrderReport->new;

    if ( defined $self->req->param('report_by_order')
        && length $self->req->param('report_by_order') )
    {

        $self->stash( report_cat => 'Order' );
        $self->stash(
            column_heads => [ 'Order no.', 'Item Name', 'Item Price' ] );

        my @rows;
        my $result =
          $order_report->get_item_by_order(
            $self->req->param('report_by_order') )
          or return $self->render( text => 'No result found' );
        while ( my $res = $result->next ) {
            push @rows,
              [ $res->order_number, $res->item->name, $res->item->price ];
        }
        $self->stash( rows => \@rows );

    }
    elsif ( defined $self->req->param('report_by_customer')
        && length $self->req->param('report_by_customer') )
    {

        # customer full_name, item_name, item_price
        $self->stash( report_cat => 'Customer' );
        $self->stash(
            column_heads => [ 'Customer Name', 'Item Name', 'Item Price' ] );

        my @rows;
        my $result =
          $order_report->get_item_by_customer(
            $self->req->param('report_by_customer') )
          or return $self->render( text => 'No result found' );
        while ( my $res = $result->next ) {
            push @rows,
              [
                join( ' ',
                    $res->customer->first_name,
                    $res->customer->last_name ),
                $res->item->name,
                $res->item->price
              ];
        }
        $self->stash( rows => \@rows );

    }
    elsif ( defined $self->req->param('report_by_date')
        && length $self->req->param('report_by_date') )
    {

        # date, item_name, item_price
        $self->stash( report_cat => 'Date' );
        $self->stash( column_heads => [ 'Date', 'Item Name', 'Item Price' ] );

        my @rows;
        my $result =
          $order_report->get_item_by_date( $self->req->param('report_by_date') )
          or return $self->render( text => 'No result found' );
        while ( my $res = $result->next ) {
            my $dt = DateTime->from_epoch( epoch => $res->order_date );
            my $datetime = join(' ', $dt->ymd, $dt->hms);
            push @rows,
              [ $datetime, $res->item->name, $res->item->price ];
        }
        $self->stash( rows => \@rows );

    }
    else {
        return $self->render( text => 'Invalid param' );
    }

    return $self->render( template => 'report/do_report' );
}

1;
