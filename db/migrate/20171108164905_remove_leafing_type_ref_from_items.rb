class RemoveLeafingTypeRefFromItems < ActiveRecord::Migration
  def change
    remove_reference :items, :leafing_type, foreign_key: true, index: true
  end
end
