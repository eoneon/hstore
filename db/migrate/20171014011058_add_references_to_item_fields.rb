class AddReferencesToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :dimension_type, index: true, foreign_key: true
    add_reference :item_fields, :leafing_type, index: true, foreign_key: true
    add_reference :item_fields, :remarque_type, index: true, foreign_key: true
  end
end
