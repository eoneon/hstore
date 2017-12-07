class AddDisclaimerTypeReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :disclaimer_type, index: true, foreign_key: true
  end
end
