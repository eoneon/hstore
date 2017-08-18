class AddSubstrateTypeReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :substrate_type, index: true, foreign_key: true
  end
end
