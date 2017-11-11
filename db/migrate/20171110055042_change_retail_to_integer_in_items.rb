class ChangeRetailToIntegerInItems < ActiveRecord::Migration
  def change
    change_column :items, :retail, :integer
  end
end
