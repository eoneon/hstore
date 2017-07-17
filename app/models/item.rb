class Item < ActiveRecord::Base
  belongs_to :item_type
  serialize :properties, Hash
end
