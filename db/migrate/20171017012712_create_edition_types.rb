class CreateEditionTypes < ActiveRecord::Migration
  def change
    create_table :edition_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
