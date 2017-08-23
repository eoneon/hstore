class CreateArtistItems < ActiveRecord::Migration
  def change
    create_table :artist_items do |t|
      t.references :artist, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
