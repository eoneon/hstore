class AddReferenceToItems < ActiveRecord::Migration
  def change
    add_reference :items, :artist, index: true, foreign_key: true
  end
end
