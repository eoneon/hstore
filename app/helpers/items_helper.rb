module ItemsHelper
  def title(item)
    conditional_capitalize(item.title)
  end

  def item_title(item)
    "\"#{title(item)}\"" if item.title != "Untitled"
  end

  def raw_retail(item)
    number_with_precision(item.retail, precision: 2)
  end

  #pr_retails
  def retail(item)
    if item.retail.present? && item.retail > 0
      " List #{number_to_currency(item.retail, precision: 0)}"
    end
  end
end
