use utf8;
package AcmeStore::Schema::Result::Order;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AcmeStore::Schema::Result::Order

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<orders>

=cut

__PACKAGE__->table("orders");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 order_number

  data_type: 'text'
  is_nullable: 1

=head2 order_date

  data_type: 'numeric'
  is_nullable: 1

=head2 customer_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 item_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "order_number",
  { data_type => "text", is_nullable => 1 },
  "order_date",
  { data_type => "numeric", is_nullable => 1 },
  "customer_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "item_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 customer

Type: belongs_to

Related object: L<AcmeStore::Schema::Result::Customer>

=cut

__PACKAGE__->belongs_to(
  "customer",
  "AcmeStore::Schema::Result::Customer",
  { id => "customer_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 item

Type: belongs_to

Related object: L<AcmeStore::Schema::Result::Item>

=cut

__PACKAGE__->belongs_to(
  "item",
  "AcmeStore::Schema::Result::Item",
  { id => "item_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-29 17:49:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kYn+IWQH+BwbEEgbkNvCYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
