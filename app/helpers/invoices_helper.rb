module InvoicesHelper
  def item_sku(item)
    sku_ = item.sku.nil? ? "update" : item.sku
    return sku_
  end
end
