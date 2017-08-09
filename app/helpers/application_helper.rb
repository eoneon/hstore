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

  def items_format(item, item_type_name, item_properties)
    if item_type_name == "original painting"
      painting_type = item_type_name.split
      painting_type = painting_type.insert(1, item_properties["paint_type"]) #original oil painting
      if item.mounting_type.name == "framed" || item.mounting_type == "unframed"
        painting_type = painting_type.unshift(item.mounting_type.name) #framed original oil painting
        painting_type << "on " + item_properties["substrate"] + "," #framed original oil painting on canvas
        painting_type << item.signature_type.name
      elsif item.mounting_type.name == "gallery wrapped" || item.mounting_type == "stretched"
        painting_type << "on " + item.mounting_type.name + " " + item_properties["substrate"] #original oil painting on stretched canvas
      end

      if item.certificate_type.name?
        painting_type << "with " + item.certificate_type.name
      end
    end
    return painting_type.join(" ")
  end
end
