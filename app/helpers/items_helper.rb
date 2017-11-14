module ItemsHelper
  def item_title(item)
    "\"#{conditional_capitalize(item.title)}\"" if item.title != "Untitled"
  end

  def retail(item)
    number_to_currency(item.retail)
  end
end
