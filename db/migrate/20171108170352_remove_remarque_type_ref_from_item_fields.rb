class RemoveRemarqueTypeRefFromItemFields < ActiveRecord::Migration
  def change
    remove_reference :item_fields, :remarque_type, foreign_key: true, index: true
  end
end
