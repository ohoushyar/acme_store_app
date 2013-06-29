package AcmeStore::Model::Base;

use strict;
use warnings;

use Mo qw(builder default);

use AcmeStore::Schema;

has 'filename' => (
    is      => 'rw',
    default => 'db/acme_store_db',
);
has 'schema' => (
    builder => 'schema_builder',
    lazy    => 1,
);

sub schema_builder {
    my $self = shift;
    my $dsn  = 'dbi:SQLite:dbname=' . $self->filename;

    return AcmeStore::Schema->connect($dsn);
}

1;
