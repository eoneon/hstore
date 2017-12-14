class Artist < ActiveRecord::Base
  has_many :artist_items, dependent: :destroy
  has_many :items, through: :artist_items
  has_many :displays, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :displays, allow_destroy: true

  before_save :mark_children_for_removal

  def mark_children_for_removal
    displays.each do |display|
      display.mark_for_destruction if display.name.blank?
    end
  end

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end

  def full_display_name
    [full_name, artist_display].join(" ")
  end

  #remove
  def last_name_display
    [last_name, artist_display].join(" ")
  end

  def last_name_first
    ([last_name, first_name] - ['']).compact.join(', ')
  end

  def artist_display
    displays.first.name if displays.present?
  end

  #target
  def dob
    if displays.present?
      dob = displays.first.name.split(" ").last #=> (2000 - 2015)
      if dob.first == "(" && dob.last == ")"
        [dob.strip.split("-").first[1..4], dob.strip.split("-").last[1..4]] #[2000, 2015]
      end
    end
  end
end
