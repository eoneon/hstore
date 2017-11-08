class DropRemarqueTypes < ActiveRecord::Migration
  def change
    drop_table :remarque_types
  end
end
