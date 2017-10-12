class CreateDimensionTypes < ActiveRecord::Migration
  def change
    create_table :dimension_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
