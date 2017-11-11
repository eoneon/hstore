module ItemTypesHelper
  def flat_item_list
    ItemType.all.map {|item| item.id unless [item.name].any? {|name| name.include?("sculpture")}}.reject {|item| item.nil?}
  end

  def sculpture_item_list
    ItemType.all.map {|item| item.id if [item.name].any? {|name| name.include?("sculpture")}}.reject {|item| item.nil?}
  end
end
