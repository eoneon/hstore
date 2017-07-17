class AddPropertiesToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :properties, :string
  end
end
