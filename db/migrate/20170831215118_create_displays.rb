class CreateDisplays < ActiveRecord::Migration
  def change
    create_table :displays do |t|
      t.string :name
      t.references :artist, :invoice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
