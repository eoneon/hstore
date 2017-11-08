class DropLeafingTypeModel < ActiveRecord::Migration
  def change
    drop_table :leafing_types
  end
end
