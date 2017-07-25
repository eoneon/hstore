class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :artist
  serialize :properties, Hash
  delegate :first_name, :last_name, :to => :artist
end
