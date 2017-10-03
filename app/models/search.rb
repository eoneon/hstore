class Search < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
  belongs_to :substrate_type
  belongs_to :signature_type
  belongs_to :certificate_type

  serialize :properties, Hash

  def items
    @items ||= find_items
  end

  private

  def find_items
    items = Item.order(:sku)
    items = items.where(item_type_id: item_type_id) if item_type_id.present?
    items = items.where(mounting_type_id: mounting_type_id) if mounting_type_id.present?
    items = items.where(substrate_type_id: substrate_type_id) if substrate_type_id.present?
    items = items.where(certificate_type_id: certificate_type_id) if certificate_type_id.present?
    self.properties.each do |k, v|
      items = items.where("properties @> hstore(:key,:value)", key: k, value: v) if properties[k].present? #&& properties[k] != 0
    end
    # items = items.where("name like ?", "%#{keywords}%") if keywords.present?
    # items = items.where(item_type_id: item_type_id) if item_type_id.present?
    # items = items.where("properties @> hstore(:key, :value)", key: "paint_type", value: "Oil Painting") if properties["paint_type"].present?
    # items = items.where("properties @> hstore(:key, :value)", key: "mounting_type", value: "Framed") if properties.present?
    # items = items.where("properties @> hstore(:key, :value)", key: "mounting", value: "framed") if properties.present?
    #items = items.where("price <= ?", max_price) if max_price.present?
    items
  end

end
