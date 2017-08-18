class AddDetailsToItems < ActiveRecord::Migration
  def change
    add_column :items, :image_width, :integer
    add_column :items, :image_height, :integer
  end
end
