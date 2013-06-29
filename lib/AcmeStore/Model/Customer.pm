package AcmeStore::Model::Customer;

use strict;
use warnings;

use Mo qw(build default required);
extends 'AcmeStore::Model::Base';

has 'first_name' => (is => 'rw');
has 'last_name' => (is => 'rw');

sub BUILD {
    my $self = shift;


}

sub save {
    my $self = shift;

}

1;


