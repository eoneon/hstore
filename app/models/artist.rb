class Artist < ActiveRecord::Base
  has_many :items

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end

  def last_name_first
    ([last_name, first_name] - ['']).compact.join(', ')
  end
end
