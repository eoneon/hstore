class AddMountingTypeReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :mounting_type, index: true, foreign_key: true
  end
end
