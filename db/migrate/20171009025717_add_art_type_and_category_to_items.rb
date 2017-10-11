class AddArtTypeAndCategoryToItems < ActiveRecord::Migration
  def change
    add_column :items, :art_type, :string
    add_column :items, :category, :string
  end
end
