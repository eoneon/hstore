class CreateValueItems < ActiveRecord::Migration
  def change
    create_table :value_items do |t|
      t.string :kind
      t.string :name
      t.integer :sort

      t.timestamps null: false
    end
  end
end
