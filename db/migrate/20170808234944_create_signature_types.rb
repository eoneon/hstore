class CreateSignatureTypes < ActiveRecord::Migration
  def change
    create_table :signature_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
