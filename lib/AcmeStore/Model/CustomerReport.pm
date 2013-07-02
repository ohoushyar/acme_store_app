package AcmeStore::Model::CustomerReport;

use Carp;
use strict;
use warnings;

use Mo;
extends 'AcmeStore::Model::Base';

sub get_all_customers {
    my $self   = shift;
    my $schema = $self->schema;

    my @result;

    eval { @result = $schema->resultset('Customer')->all; };
    croak("Unable to get data; ERROR[$@]") if $@;

    my @res;
    push @res, { id => $_->id, first_name => $_->first_name, last_name => $_->last_name, } for @result;

    return \@res;
}

1;

