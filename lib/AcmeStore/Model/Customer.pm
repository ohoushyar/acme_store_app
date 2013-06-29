package AcmeStore::Model::Customer;

use strict;
use warnings;

use Mo qw(default required);
extends 'AcmeStore::Model::Base';

has 'id' => ( is => 'rw', required => 1 );
has 'first_name' => ( is => 'rw' );
has 'last_name'  => ( is => 'rw' );

sub save {
    my $self   = shift;
    my $schema = $self->schema;
    my $result;

    #$schema->storage->debug(1);
    eval {
        $result = $schema->resultset('Customer')->find_or_create(
            {
                id         => $self->id,
                first_name => $self->first_name,
                last_name  => $self->last_name,
            },
            { key => 'primary' },
        );
    };
    if ($@) {
        Carp::croak("Unable to save customer; ERROR: [$@]");
        return;
    }

    return $result;
}

1;

