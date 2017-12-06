class AddReserveTypesReferenceToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :reserve_type, index: true, foreign_key: true
  end
end
