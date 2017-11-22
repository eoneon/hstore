module ItemTypesHelper
  def flat_art_list
    ItemType.all.map {|item| item.id unless [item.name].any? {|name| name.include?("sculpture")}}.reject {|item| item.nil?}
  end

  def sculpture_list
    ItemType.all.map {|item| item.id if [item.name].any? {|name| name.include?("sculpture")}}.reject {|item| item.nil?}
  end
end
