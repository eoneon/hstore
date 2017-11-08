class RemoveMountTypeRefFromItemFields < ActiveRecord::Migration
  def change
    remove_reference :item_fields, :mounting_type, index: true, foreign_key: true
  end
end
