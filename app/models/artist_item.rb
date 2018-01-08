class ArtistItem < ActiveRecord::Base
  belongs_to :artist
  belongs_to :item

  # def self.update_join(artist, item)
  #   ArtistItem.find_or_create_by(artist_id: artist, item_id: item)
  # end
end
