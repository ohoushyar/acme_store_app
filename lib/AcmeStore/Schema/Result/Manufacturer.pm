use utf8;
package AcmeStore::Schema::Result::Manufacturer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AcmeStore::Schema::Result::Manufacturer

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<MANUFACTURERS>

=cut

__PACKAGE__->table("MANUFACTURERS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-28 19:22:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jvqWVGnDDzUUfTZ8RW6/Jg


__PACKAGE__->add_unique_constraint(
    name => [ qw/name/ ],
);

1;
