class RemoveInvoiceReferenceFromDisplays < ActiveRecord::Migration
  def change
    remove_reference :displays, :invoice, index: true, foreign_key: true
  end
end
