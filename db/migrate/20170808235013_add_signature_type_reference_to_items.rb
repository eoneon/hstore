class AddSignatureTypeReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :signature_type, index: true, foreign_key: true
  end
end
