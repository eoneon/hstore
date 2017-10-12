class CreateRemarqueTypes < ActiveRecord::Migration
  def change
    create_table :remarque_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
