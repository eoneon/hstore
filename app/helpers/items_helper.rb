module ItemsHelper
  def item_title(item)
    "\"#{conditional_capitalize(item.title)}\"" if item.title != "Untitled"
  end

  def retail(item)
    if item.retail.present?
      " List #{number_to_currency(item.retail, precision: 0)}"
    end
  end
end
