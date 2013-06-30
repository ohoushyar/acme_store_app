use utf8;
package AcmeStore::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AcmeStore::Schema::Result::Item

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<items>

=cut

__PACKAGE__->table("items");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'text'
  is_nullable: 1

=head2 manufacturer_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "text", is_nullable => 1 },
  "manufacturer_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<AcmeStore::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "AcmeStore::Schema::Result::Order",
  { "foreign.item_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-29 17:49:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GwzuW5x6Q0fjooNe9jnF0g

=head2 name_price_manufacturer

Type: unique constraint

=cut

__PACKAGE__->add_unique_constraint(
    name_price_manufacturer => [ qw/name price manufacturer_id/ ],
);


=head2 manufacturer

Type: belongs_to

Related object: L<AcmeStore::Schema::Result::Manufacturer>

=cut

__PACKAGE__->belongs_to(
  "manufacturer",
  "AcmeStore::Schema::Result::Manufacturer",
  { id => "manufacturer_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


1;
