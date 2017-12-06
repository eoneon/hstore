class CreateReserveTypes < ActiveRecord::Migration
  def change
    create_table :reserve_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
