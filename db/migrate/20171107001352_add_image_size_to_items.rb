class AddImageSizeToItems < ActiveRecord::Migration
  def change
    add_column :items, :image_size, :float
  end
end
