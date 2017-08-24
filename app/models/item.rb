class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type

  has_many :artist_items
  has_many :artists, through: :artist_items
  delegate :first_name, :last_name, :to => :artist
end
