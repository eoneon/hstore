class AddDetailsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :category, :string
    add_column :categories, :art_type, :string
  end
end
