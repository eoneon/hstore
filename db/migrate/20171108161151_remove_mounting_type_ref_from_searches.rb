class RemoveMountingTypeRefFromSearches < ActiveRecord::Migration
  def change
    remove_reference :searches, :mounting_type, index: true, foreign_key: true
  end
end
