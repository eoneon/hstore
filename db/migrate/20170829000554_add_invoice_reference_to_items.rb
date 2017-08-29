class AddInvoiceReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :invoice, index: true, foreign_key: true
  end
end
