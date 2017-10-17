class AddReferenceEditionTypeToItems < ActiveRecord::Migration
  def change
    add_reference :items, :edition_type, index: true, foreign_key: true
  end
end
