class AddArtistIdtoSearches < ActiveRecord::Migration
  def change
    add_column :searches, :artist_id, :integer
  end
end
