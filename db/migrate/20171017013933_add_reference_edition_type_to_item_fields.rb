class AddReferenceEditionTypeToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :edition_type, index: true, foreign_key: true
  end
end
