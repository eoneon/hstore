class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type

  has_many :artist_items, dependent: :destroy
  has_many :artists, through: :artist_items
  has_many :title_items, dependent: :destroy
  has_many :titles, through: :title_items
  accepts_nested_attributes_for :titles
  delegate :first_name, :last_name, :to => :artist
end
