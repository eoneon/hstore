class AddNameToItemFields < ActiveRecord::Migration
  def change
    add_column :item_fields, :name, :string
  end
end
