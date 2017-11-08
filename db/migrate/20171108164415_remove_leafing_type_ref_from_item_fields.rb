class RemoveLeafingTypeRefFromItemFields < ActiveRecord::Migration
  def change
    remove_reference :item_fields, :leafing_type, index: true, foreign_key: true
  end
end
