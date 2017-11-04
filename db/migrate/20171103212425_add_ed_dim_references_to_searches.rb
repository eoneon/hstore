class AddEdDimReferencesToSearches < ActiveRecord::Migration
  def change
    add_reference :searches, :edition_type, index: true, foreign_key: true
    add_reference :searches, :dimension_type, index: true, foreign_key: true
  end
end
