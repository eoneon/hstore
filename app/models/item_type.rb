class ItemType < ActiveRecord::Base
  has_many :fields, class_name: "ItemField", dependent: :destroy
  accepts_nested_attributes_for :fields, allow_destroy: true

  has_many :searches, dependent: :nullify
end
