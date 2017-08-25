class CreateTitleItems < ActiveRecord::Migration
  def change
    create_table :title_items do |t|
      t.references :title, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
