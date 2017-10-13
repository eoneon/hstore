class AddReferencesToItems < ActiveRecord::Migration
  def change
    add_reference :items, :dimension_type, index: true, foreign_key: true
    add_reference :items, :embellish_type, index: true, foreign_key: true
    add_reference :items, :leafing_type, index: true, foreign_key: true
    add_reference :items, :remarque_type, index: true, foreign_key: true
  end
end
