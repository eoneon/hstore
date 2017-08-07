class AddMountingTypeReferenceToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :mounting_type, index: true, foreign_key: true
  end
end
