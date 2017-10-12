class CreateEmbellishTypes < ActiveRecord::Migration
  def change
    create_table :embellish_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
