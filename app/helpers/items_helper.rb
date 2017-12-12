module ItemsHelper
  def prev_next(item)
    items = Item.where(invoice_id: item.invoice_id).order(:sku) #get filtered/ordered skus by invoice
    pos = items.index(item) #get position of current item
    prev_sku = pos == 0 ? 0 : pos -1
    next_sku = pos == items.count - 1 ? pos : pos + 1
    [items[prev_sku], items[next_sku]] #get item at nest pos + 1/pos -1
  end

  def title(item)
    conditional_capitalize(item.title)
  end

  def title_header(item)
    "\"#{title(item)}\""
  end

  def title_inv(item)
    title(item)[0..12]
  end

  def item_title(item)
    "\"#{title(item)}\"" if item.title != "Untitled"
  end

  def raw_retail(item)
    number_with_precision(item.retail, precision: 2, delimiter: ',')
  end

  #pr_retails
  def retail(item)
    if item.retail.present? && item.retail > 0
      "List #{number_to_currency(item.retail, precision: 0, delimiter: ',')}"
    end
  end

  def retail_inv(item)
    if item.retail.present?
      number_to_currency(item.retail, precision: 0, delimiter: ',')
    end
  end
end
