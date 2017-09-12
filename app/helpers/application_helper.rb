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
  # def item_type
  #   ["original painting", "one-of-a-kind", "original sketch"]
  #   ["limited edition", "print", "poster"]
  # end

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

  #limited editions
  def limited_type
    ["limited edition", "sold out limited edition", "(nfs) limited edition"]
  end

  def ink_type
    ["lithograph", "serigraph", "giclee", "etching", "sericel"]
  end

  def numbering_type
    ["standard", "AP", "PP", "HC"]
  end

  def extras_type
    ["hand_embellished", "remarque", "golden leaf", "silver leaf"]
  end

  #authentication_type
  def authentication_type
    ["certificate of authenticty", "letter of authenticty", "certificate of authenticty from Peter Max Studios", "none"] #PSA/BA, presented with...
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

  def items_format(item)
    "#{item.artists_names} #{item.item_title} #{item.item_mounting_type} #{item.art_type} #{item.media_type} #{item.item_substrate_type} #{item.item_number_type} #{item.item_signature_type} #{item.item_remarque} #{item.item_certificate_type}." 
  end
end
