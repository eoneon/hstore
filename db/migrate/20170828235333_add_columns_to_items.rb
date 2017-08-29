class AddColumnsToItems < ActiveRecord::Migration
  def change
    add_column :items, :retail, :decimal
    add_column :items, :title, :text
    add_column :items, :sku, :integer
  end
end
