class RemoveMountingTypeRefereneceFromItems < ActiveRecord::Migration
  def change
    #remove_reference :items, :mounting_type, index: true, foreign_key: true
  end
end
