class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :invoice
      t.string :name

      t.timestamps null: false
    end
  end
end
