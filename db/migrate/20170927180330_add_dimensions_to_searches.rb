class AddDimensionsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :image_width, :integer
    add_column :searches, :image_height, :integer
  end
end
