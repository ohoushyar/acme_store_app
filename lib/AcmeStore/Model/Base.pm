package AcmeStore::Model::Base;

use strict;
use warnings;

use Mo;

use constant FILENAME => 'db/acme_store_db';

has 'schema' => (
    builder => 'schema_builder',
    lazy => 1,
);

sub schema_builder {
    my $self = shift;
    my $dsn = 'dbi:SQLite:dbname='.FILENAME;

    return AcmeStore::Schema->connect( $dsn );
}

1;
