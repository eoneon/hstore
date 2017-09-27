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
  #   ["Original Painting", "Limited Edition", "One-of-a-Kind", "Print", "Poster", "Original Sketch"]
  # end

  #substrate_type values*
  def substrate_type
    ["Canvas", "Paper", "Other"]
  end

  #mounting_type values
  def mounting_type
    ["Framed", "Unframed without border", "Unframed with border"]
  end

  #original medias
  def paint_type
    ["Oil Painting", "Acrylic Painting", "Watercolor Painting", "Oil and Acrylic Painting", "Pastel Painting", "Guache Painting"]
  end

  def mixed_media_type
    ["Mixed Media", "Mixed Media Acrylic", "Monoprint", "Numbered Monoprint"]
  end

  def sketch_type
    ["Pencil", "Colored Pencil", "Pen & Ink"]
  end

  def sketch_media_type
    ["Sketch", "Drawing"]
  end

  def canvas_type
    if @item.mounting_type.name == "Framed"
      ["Canvas", "Canvas Board", "Textured Canvas", "Textured Canvas Board"]
    else
      ["Canvas", "Gallery Wrapped Canvas", "Stretched Canvas", "Canvas Board", "Textured Canvas", "Textured Canvas Board"]
    end
  end

  def paper_type
    ["Paper", "Archival Paper", "Deckle Edge Paper", "Rice Paper", "Japanese Rice Paper"]
  end

  def other_type
    ["Wood", "Wood Panel", "Metal", "Metal Panel", "Resin", "Board", "Tile"]
  end

  #limited editions
  def limited_type
    ["Limited Edition", "Sold Out Limited Edition", "(NFS) Limited Edition"]
  end

  def ink_type
    ["Lithograph", "Serigraph", "Giclee", "Etching", "Sericel"]
  end

  def numbering_type
    ["Standard", "AP", "PP", "HC"]
  end

  def extras_type
    ["Hand Embellished", "Remarque", "Gold Leaf", "Silver Leaf"]
  end

  #authentication_type
  def authentication_type
    ["Certificate of Authenticty", "Letter of Authenticty", "Certificate of Authenticty from Peter Max Studios", "none"] #PSA/BA, presented with...
  end

  #signature_type
  def signature_type
    ["Hand Signed", "Plate Signed", "Official Signature"] #double-signature, nom-de-plum
  end

  def value_list(property)
    send(property)
  end

  def set_value(value)
    if value != nil
      @item.properties["#{value}"]
    else
      nil
    end
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
    artists = "#{item.artists_names} -" unless item.artists_names.nil?
    "#{artists} #{item.item_title} #{item.item_mounting_type} #{item.art_type} #{item.embellish_type} #{item.media_type} #{item.item_substrate_type} #{item.leafing_type} #{item.item_remarque} #{item.item_signature_type} #{item.item_certificate_type}. #{item.item_dimensions}"
  end

  def items_tagline(item)
    artists = "#{item.artists_names} -" unless item.artists_names.nil?
    title = "\"#{item.item_title}\"" unless item.item_title.downcase == "untitled"
    if item.item_mounting_type != nil
      mounting = "#{item.item_mounting_type}" if item.item_mounting_type == "Framed"
    end
    media = "#{item.media_type}" if item.media_type != "Giclee"
    substrate = "on #{item.item_substrate_type}" unless item.item_substrate_type.nil? || item.item_substrate_type.split(" ").last == "Paper"
    "Tagline: #{artists} #{title} #{mounting} #{item.art_type} #{item.embellish_type} #{media} #{substrate}, #{item.leafing_type} #{item.item_remarque} #{item.item_signature_type} #{item.item_certificate_type}.".gsub(/ ,/, ',')
  end

  def items_description(item)
    if item.art_type != nil
      if item.item_title == "Untitled"
        intro = item.art_type[0] =~ /\A[^aeiou]/ ? "This is a " : "This is an "
      else
        intro = item.art_type[0] =~ /\A[^aeiou]/ ? "\"#{item.item_title}\" is a " : "\"#{item.item_title}\" is an "
      end
    end

    if item.art_type != nil
      art_type = item.item_mounting_type == "Framed" && item.properties["custom_framed"] != "1" ? "Framed #{item.art_type.downcase}" : item.art_type.downcase
    end

    if item.properties != nil
      custom_framed = "This piece comes custom framed." if item.properties["custom_framed"] == "1"
    end

    if item.properties != nil && item.signature_type != nil
      signature = "hand signed by the artist" if item.signature_type.name == "Signature"
    end

    if item.properties != nil && item.certificate_type != nil
      certificate = "Includes Certificate of Authenticity." if item.certificate_type.name == "Authentication"
    end

    media = "#{item.media_type}".downcase
    artists = "by #{item.artists_names}," unless item.artists_names.nil?
    title = "#{item.item_title}" unless item.item_title == "Untitled"
    mounting = "#{item.item_mounting_type}" if item.item_mounting_type == "Framed"
    substrate = "on #{item.item_substrate_type.downcase}" unless item.item_substrate_type.nil?

    "Description: #{intro} #{art_type} #{item.embellish_type} #{media} #{substrate} #{item.leafing_type} #{artists} #{item.item_remarque} #{signature}. #{custom_framed} #{certificate} #{item.item_dimensions}.".gsub(/ ,/, ',')
  end
end
