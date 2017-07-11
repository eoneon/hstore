class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :keywords
      t.references :item_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
