module ApplicationHelper
  #see rails cast 196
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def property_list(key)
    items = Item.where("properties ? :key", key: key).distinct
    properties = items.pluck(:properties)
    values = []
    properties.each do |property|
      values << property[key]
    end
    return values
  end

  def paint_types
    ["oil", "acrylic", "water color", "mixed media", "unknown", "guache", "oil and acrylic"]
  end
end
