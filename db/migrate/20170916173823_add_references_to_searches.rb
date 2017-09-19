class AddReferencesToSearches < ActiveRecord::Migration
  def change
    add_reference :searches, :mounting_type, index: true, foreign_key: true
    add_reference :searches, :substrate_type, index: true, foreign_key: true
    add_reference :searches, :signature_type, index: true, foreign_key: true
    add_reference :searches, :certificate_type, index: true, foreign_key: true
  end
end
