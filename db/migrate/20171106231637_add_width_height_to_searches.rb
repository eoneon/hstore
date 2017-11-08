class AddWidthHeightToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :width, :float
    add_column :searches, :height, :float
  end
end
