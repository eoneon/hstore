class RemoveArtTypeFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :art_type, :string
  end
end
