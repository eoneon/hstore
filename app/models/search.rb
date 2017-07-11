class Search < ActiveRecord::Base
  belongs_to :item_type

  def items
    @items ||= find_items
  end

  private

  def find_items
    items = Item.order(:name)
    items = items.where("name like ?", "%#{keywords}%") if keywords.present?
    items = items.where(item_type_id: item_type_id) if item_type_id.present?
    #items = items.where("price >= ?", min_price) if min_price.present?
    #items = items.where("price <= ?", max_price) if max_price.present?
    items
  end
end
