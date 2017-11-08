class DropMountTypes < ActiveRecord::Migration
  def change
    drop_table :mounting_types
  end
end
