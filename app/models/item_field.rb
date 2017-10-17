class ItemField < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :dimension_type
  belongs_to :mounting_type
  belongs_to :edition_type
  belongs_to :leafing_type
  belongs_to :remarque_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type
end
