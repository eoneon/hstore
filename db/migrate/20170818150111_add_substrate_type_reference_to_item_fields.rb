class AddSubstrateTypeReferenceToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :substrate_type, index: true, foreign_key: true
  end
end
