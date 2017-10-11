class RemoveCategoryFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :category, :string
  end
end
