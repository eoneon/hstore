class Artist < ActiveRecord::Base
  has_many :artist_items
  has_many :items, through: :artist_items
  has_many :displays, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :displays, allow_destroy: true
                                # reject_if: proc { |a| a[:name].blank? },
                                # allow_destroy: true

  before_save :mark_children_for_removal

  def mark_children_for_removal
    displays.each do |display|
      display.mark_for_destruction if display.name.blank?
    end
  end

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end

  def last_name_first
    ([last_name, first_name] - ['']).compact.join(', ')
  end
end
