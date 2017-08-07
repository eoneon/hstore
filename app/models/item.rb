class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
  belongs_to :artist
  delegate :first_name, :last_name, :to => :artist
end
