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

  #ItemType values
  def item_type
    ["original painting", "one-of-a-kind", "original sketch"]
  end

  #substrate_type values*
  def substrate_type
    ["canvas", "paper", "other"]
  end

  #mounting_type values
  def mounting_type
    ["framed", "unframed without border", "unframed with border"]
  end

  #original medias
  def paint_type
    ["oil painting", "acrylic painting", "watercolor painting", "oil and acrylic painting", "pastel painting", "guache painting", "etching"]
  end

  def mixed_media_type
    ["mixed media", "mixed media acrylic", "monoprint", "numbered monoprint"]
  end

  def sketch_type
    ["pencil", "colored pencil", "pen & ink"]
  end

  def sketch_media_type
    ["sketch", "drawing"]
  end

  def canvas_type
    ["canvas", "gallery wrapped canvas", "stretched canvas", "canvas board", "textured canvas", "textured canvas board"]
  end

  def paper_type
    ["paper", "archival paper", "deckle edge paper", "rice paper", "Japanese rice paper"]
  end

  def other_type
    ["wood", "wood panel", "metal", "metal panel", "resin", "board"]
  end

  #authentication_type
  def authentication_type
    ["certificate of authenticiy", "letter of authenticiy", "certificate of authenticiy from Peter Max Studios", "none"] #PSA/BA, presented with...
  end

  #signature_type
  def signature_type
    ["hand signed", "plate signed", "official signature"] #double-signature, nom-de-plum
  end

  def value_list(property)
    return send(property)
  end


  # def property_list(key)
  #   items = Item.where("properties ? :key", key: key).distinct
  #   properties = items.pluck(:properties)
  #   values = []
  #   properties.each do |property|
  #     values << property[key]
  #   end
  #   return values
  # end

  def items_format(item, item_type_name, item_properties)
    if item_type_name == "original painting"

      #mounting = 
      original = item_type_name.partition(" ").first #original
      painting_type = item_properties["paint_type"] #oil painting
      original_painting = original + " " + painting_type
      #painting_type = item_type_name.split
      #painting_type = painting_type[0]
      #painting_type << painting_type.insert(1, item_properties["paint_type"]) #original oil painting
      #if item.mounting_type.name == "framed" || item.mounting_type == "unframed"
      #   painting_type = painting_type.unshift(item.mounting_type.name) #framed original oil painting
      #   painting_type << "on " + item_properties["substrate"] + "," #framed original oil painting on canvas
      #   painting_type << item.signature_type.name
      # elsif item.mounting_type.name == "gallery wrapped" || item.mounting_type == "stretched"
      #   painting_type << "on " + item.mounting_type.name + " " + item_properties["substrate"] #original oil painting on stretched canvas
      # end

      # if item.certificate_type.name?
      #   painting_type << "with " + item.certificate_type.name
      # end
    end
    return original_painting #painting_type.join(" ")
  end
end
