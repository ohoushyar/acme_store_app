package AcmeStore::Model::Manufacturer;

use strict;
use warnings;

use Mo qw(default required);
extends 'AcmeStore::Model::Base';

has 'id' => ( is => 'rw');
has 'name' => ( is => 'rw', required => 1 );

sub save {
    my $self   = shift;
    my $schema = $self->schema;
    my $result;

    #$schema->storage->debug(1);
    eval {
        $result = $schema->resultset('Manufacturer')->find_or_create(
            {
                name => $self->name,
            },
            { key => 'name' },
        );
    };
    if ($@) {
        Carp::croak("Unable to save Manufacturer; ERROR: [$@]");
        return;
    }

    return $result;
}

1;

