class RemoveRemarqueTypeRefFromItems < ActiveRecord::Migration
  def change
    remove_reference :items, :remarque_type, foreign_key: true, index: true
  end
end
