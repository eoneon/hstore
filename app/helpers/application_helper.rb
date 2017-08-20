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
    item_type = item.item_type.name
    artist = "#{item.artist.full_name} -" if item.artist
    substrate = item.properties["#{item.substrate_type.name}_type"] #equivalent of prev step
    mounting = item.mounting_type.name.split(" ").first if substrate.split(" ").first != ("gallery" || "stretched") #get mounting_type_name, conditionally prepend it to  return value if substrate_type not gallery or stretched
    signature = "hand signed by the artist" if item.signature_type.name == "signature"
    authentication = "with #{item.properties["authentication_type"]}" if item.certificate_type.name == "authentication"
    if item_type == "original painting"
      _item = item.item_type.name.split(" ").first #original
      media = item.properties["paint_type"] #oil painting
    elsif item_type == "one-of-a-kind"
      _item = item_type
      media = item.properties["mixed_media_type"]
    elsif item_type == "original sketch"
      _item = item.item_type.name
      media = item.properties["sketch_media_type"]
    elsif item_type == "limited edition"
      _item = item.properties["limited_type"]
      media = item.properties["hand_embellished"] == "1" ? "hand embellished #{item.properties["ink_type"]}" : item.properties["ink_type"]
      media = item.properties["gold_leaf"] == "1" ? "#{media} with gold leaf" : media
      media = item.properties["silver_leaf"] == "1" ? "#{media} with silver leaf" : media
      remarq = "with hand drawn remarque" if item.properties["remarque"] == "1"
      numbering = item.properties["numbering_type"] != "standard" ? "#{item.properties["numbering_type"]} numbered" : "numbered"
      numbering = "#{numbering} #{item.properties["number"]}/#{item.properties["edition_size"]}" unless item.properties["number"].empty?
      numbering = "#{numbering} from an edition of #{item.properties["edition_size"]}" if item.properties["number"].empty?
    end
    return "#{artist} #{mounting} #{_item} #{media} on #{substrate} #{numbering} #{signature} #{remarq} #{authentication}."
  end
end
