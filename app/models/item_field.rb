class ItemField < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
end
