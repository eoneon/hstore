module InvoicesHelper
  def item_sku(item)
    sku_ = item.sku.nil? ? "edit" : item.sku
    return sku_
  end
end
