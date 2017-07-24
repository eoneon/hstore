class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :artist
  serialize :properties, Hash
end
