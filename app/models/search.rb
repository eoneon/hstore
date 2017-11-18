class Search < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :dimension_type
  belongs_to :edition_type
  belongs_to :substrate_type
  belongs_to :signature_type
  belongs_to :certificate_type

  serialize :properties, Hash
  #before_save { self.title = title.downcase if title.present? }

  def items
    @items ||= find_items
  end

  def fk_values
    [artist_id, title, item_type_id, dimension_type_id, substrate_type_id, certificate_type_id].reject {|fk| fk.nil?}.count
  end

  def image_size
    width * height if width > 0 && height > 0
  end

  private

  def width
    self.properties["width"].to_f
  end

  def height
    self.properties["height"].to_f
  end

  def find_items
    items = fk_values > 0 ? Item.order(:sku) : []
    items = items.joins(:artists).where('artists.id' => artist_id) if artist_id.present?
    items = items.where(item_type_id: item_type_id) if item_type_id.present?
    items = items.where(dimension_type_id: dimension_type_id) if dimension_type_id.present?
    items = items.where(substrate_type_id: substrate_type_id) if substrate_type_id.present?
    items = items.where(certificate_type_id: certificate_type_id) if certificate_type_id.present?
    items = items.where('title ILIKE ?', "%#{title}%") if title.present?
    items = items.where('image_size > ? AND image_size < ?', image_size - 1, image_size + 1) if image_size.present?
    properties.except("width", "height").each do |k, v|
      items = items.where("properties @> hstore(:key,:value)", key: k, value: v) if properties[k].present?
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
