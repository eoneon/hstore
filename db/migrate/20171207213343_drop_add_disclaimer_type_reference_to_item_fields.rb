class DropAddDisclaimerTypeReferenceToItemFields < ActiveRecord::Migration
  def change
    def up
      drop_table :add_disclaimer_type_reference_to_item_fields
    end
  end
end
