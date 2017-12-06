class AddReserveTypeReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :reserve_type, index: true, foreign_key: true
  end
end
