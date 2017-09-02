class Artist < ActiveRecord::Base
  has_many :artist_items
  has_many :items, through: :artist_items
  has_many :display_names, class_name: "Display", dependent: :destroy
  accepts_nested_attributes_for :display_names, allow_destroy: true


  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end

  def last_name_first
    ([last_name, first_name] - ['']).compact.join(', ')
  end
end
