class CreateCertificateTypes < ActiveRecord::Migration
  def change
    create_table :certificate_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
