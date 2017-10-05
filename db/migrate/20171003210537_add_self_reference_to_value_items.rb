class AddSelfReferenceToValueItems < ActiveRecord::Migration
  def change
    add_reference :value_items, :parent_value, index:true
  end
end
