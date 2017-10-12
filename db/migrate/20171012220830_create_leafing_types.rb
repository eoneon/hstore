class CreateLeafingTypes < ActiveRecord::Migration
  def change
    create_table :leafing_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
