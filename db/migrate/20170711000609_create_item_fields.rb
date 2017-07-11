class CreateItemFields < ActiveRecord::Migration
  def change
    create_table :item_fields do |t|
      t.string :field_type
      t.boolean :required
      t.references :item_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
