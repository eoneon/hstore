class AddSignatureTypeReferenceToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :signature_type, index: true, foreign_key: true
  end
end
