class CreateDisclaimerTypes < ActiveRecord::Migration
  def change
    create_table :disclaimer_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
