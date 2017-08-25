class Title < ActiveRecord::Base
  has_many :title_items
  has_many :items, through: :title_items
end
