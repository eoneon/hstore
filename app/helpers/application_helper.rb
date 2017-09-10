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
    unless item.properties.nil?
      item_type_name = item.item_type.name unless item.item_type.nil?

      unless item.artist_ids.nil?
        artists = item.artist_ids.map {|artist| Artist.find(artist)}
        if artists.count == 1
          artists_names = "#{artists.first.full_name} -"
        elsif artists.count > 1
          artists_names = "{artists.first.full_name} & {artists.last.full_name} -"
        end
      end

      title = item.title.blank? ? "untitled" : "\"#{item.title}\""
      retail = "List #{number_to_currency(item.retail)}" if item.retail?

      unless item_type_name.nil?
        if item_type_name == "original painting"
          art = item_type_name.split(" ").first
        elsif item_type_name == ("one-of-a-kind" || "original sketch")
          art = item_type_name
        elsif item_type_name == "limited edition"
          art = item.properties["limited_type"]
        end
      end

      if item_type_name == "original painting"
        media = item.properties["paint_type"]
      elsif item_type_name == "one-of-a-kind"
        media = item.properties["mixed_media_type"]
      elsif item_type_name == "original sketch"
        media = item.properties["sketch_media_type"]
      elsif item_type_name == "limited edition"
        media = item.properties["hand_embellished"] == "1" ? "hand embellished #{item.properties["ink_type"]}" : item.properties["ink_type"]
        media = item.properties["gold_leaf"] == "1" ? "#{media} with gold leaf" : media
        media = item.properties["silver_leaf"] == "1" ? "#{media} with silver leaf" : media
      end

      remarque = "with hand drawn remarque" if item.properties["remarque"] == "1"

      unless item.properties["numbering_type"].nil?
        numbering = item.properties["numbering_type"] != "standard" ? "#{item.properties["numbering_type"]} numbered" : "numbered"
        numbering = "#{numbering} #{item.properties["number"]}/#{item.properties["edition_size"]}" unless item.properties["number"].empty?
        numbering = "#{numbering} from an edition of #{item.properties["edition_size"]}" if item.properties["number"].empty?
      end

      substrate = item.properties["#{item.substrate_type.name}_type"] unless item.properties["#{item.substrate_type}"].nil?

      if item.substrate_type.nil? && item.mounting_type != nil
        mounting = item.mounting_type.name unless item.mounting_type.name.nil? || substrate_type_name.split(" ").first != ("gallery" || "stretched")
      end

      if item.signature_type != nil && item.signature_type.name == "signature"
        signature = "hand signed by the artist"
      end

      unless item.certificate_type.nil?
        authentication = "with #{item.properties["authentication_type"]}" if item.certificate_type.name == "authentication"
      end

  #     # substrate = item.properties["#{item.substrate_type.name}_type"] unless item.substrate_type.nil?
  #     # mounting = Item.mounting_type_name.split(" ").first if substrate.split(" ").first != ("gallery" || "stretched")
      # signature = "hand signed by the artist" if item.signature_type.name == "signature" && item.signature_type != nil
  #     # authentication = "with #{item.properties["authentication_type"]}" if item.certificate_type.name == "authentication"
  #     # if item_type_name == "original painting"
  #     #   art = Item.item_type_name.split(" ").first #original
  #     #   media = item.properties["paint_type"]
  #     # elsif Item.item_type_name == "one-of-a-kind"
  #     #   art = Item.item_type_name
  #     #   media = item.properties["mixed_media_type"]
  #     # elsif Item.item_type_name == "original sketch"
  #     #   art = Item.item_type_name
  #     #   media = item.properties["sketch_media_type"]
  #     # elsif Item.item_type_name == "limited edition"
  #     #   art = item.properties["limited_type"]
  #     #   media = item.properties["hand_embellished"] == "1" ? "hand embellished #{item.properties["ink_type"]}" : item.properties["ink_type"]
  #     #   media = item.properties["gold_leaf"] == "1" ? "#{media} with gold leaf" : media
  #     #   media = item.properties["silver_leaf"] == "1" ? "#{media} with silver leaf" : media
  #     #   remarq = "with hand drawn remarque" if item.properties["remarque"] == "1"
  #     #   numbering = item.properties["numbering_type"] != "standard" ? "#{item.properties["numbering_type"]} numbered" : "numbered"
  #     #   numbering = "#{numbering} #{item.properties["number"]}/#{item.properties["edition_size"]}" unless item.properties["number"].empty?
  #     #   numbering = "#{numbering} from an edition of #{item.properties["edition_size"]}" if item.properties["number"].empty?
  #     # end
      return "#{artists_names} #{title} #{mounting} #{art} #{media} on #{substrate} #{numbering} #{signature} #{remarque} #{authentication}."
      #   # return "#{artist} #{title} #{mounting_type_name} #{art} #{media} on #{substrate} #{numbering} #{signature_type} #{remarqe} #{authentication}."
    end
  end
  #
  # def item_type_name
  #   item.item_type.name unless item.item_type.nil?
  # end

  # def artist
  #   artists = item.artist_ids.map {|artist| Artist.find(artist)}
  #   artists.count == 1 ? "#{artists.first.full_name} -" : "{artists.first.full_name} & {artists.last.full_name} -"
  # end

  # def title
  #   item.title.blank? ? "untitled" : "\"#{item.title}\""
  # end
  #
  # def retail
  #   "List #{number_to_currency(item.retail)}" if item.retail?
  # end

  # def art
  #   unless item_type_name.nil?
  #     if item_type_name == "original painting"
  #       item_type_name.split(" ").first
  #     elsif item_type_name == ("one-of-a-kind" || "original sketch")
  #       item_type_name
  #     elsif item_type_name == "limited edition"
  #       item.properties["limited_type"]
  #     end
  #   end
  # end

  # def media
  #   if item_type_name == "original painting"
  #     media = item.properties["paint_type"]
  #   elsif item_type_name == "one-of-a-kind"
  #     media = item.properties["mixed_media_type"]
  #   elsif item_type_name == "original sketch"
  #     media = item.properties["sketch_media_type"]
  #   elsif item_type_name == "limited edition"
  #     media = item.properties["hand_embellished"] == "1" ? "hand embellished #{item.properties["ink_type"]}" : item.properties["ink_type"]
  #     media = item.properties["gold_leaf"] == "1" ? "#{media} with gold leaf" : media
  #     media = item.properties["silver_leaf"] == "1" ? "#{media} with silver leaf" : media
  #   end
  # end

  # def remarque
  #   "with hand drawn remarque" if item.properties["remarque"] == "1"
  # end

  # def numbering
  #   unless item.properties["numbering_type"].nil?
  #     numbering = item.properties["numbering_type"] != "standard" ? "#{item.properties["numbering_type"]} numbered" : "numbered"
  #     numbering = "#{numbering} #{item.properties["number"]}/#{item.properties["edition_size"]}" unless item.properties["number"].empty?
  #     numbering = "#{numbering} from an edition of #{item.properties["edition_size"]}" if item.properties["number"].empty?
  #   end
  # end

  # def substrate
  #   self.properties["#{item.substrate_type.name}_type"] unless item.properties["#{item.substrate_type.name}_type"].nil?
  # end

  # def mounting_type_name
  #   if substrate_type_name.nil?
  #     item.mounting_type.name unless item.mounting_type.name.nil? || substrate_type_name.split(" ").first != ("gallery" || "stretched")
  #   end
  # end

  # def signature_type
  #   unless item.signature_type.name.nil? && item.signature_type.name == "signature"
  #     "hand signed by the artist"
  #   end
  # end

  # def authentication
  #   unless item.certificate_type.nil?
  #     "with #{item.properties["authentication_type"]}" if item.certificate_type.name == "authentication"
  #   end
  # end

  # def items_format(item)
  #   "#{artist} #{title} #{art}"
  #   # return "#{artist} #{title} #{mounting_type_name} #{art} #{media} on #{substrate} #{numbering} #{signature_type} #{remarq} #{authentication}."
  # end
end
