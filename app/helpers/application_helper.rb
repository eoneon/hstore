module ApplicationHelper
  #see rails cast 196
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("item_types/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def obj_type_list
    type_list = [ItemType, EditionType, SubstrateType, DimensionType, SignatureType,  CertificateType] #all +EditionType,
    if @item.item_type.name == "limited edition"
      type_list
    elsif @item.item_type.name == "print"
      type_list - [EditionType]
    elsif @item.item_type.name == "limited edition sculpture"
      type_list - [SubstrateType]
    elsif @item.item_type.name == "sculpture"
      type_list - [EditionType, SubstrateType]
    elsif @item.item_type.name == "one-of-a-kind"
      type_list
    elsif @item.item_type.name == "original painting" || @item.item_type.name == "sketch"
      type_list - [EditionType] #- [EditionType]
    end
  end

  def obj_to_s(obj)
    obj.to_s.underscore
  end

  def obj_to_str(obj)
    obj.class.name.underscore
  end

  def obj_to_fk(obj)
    obj.to_s.underscore + "_id"
  end

  def obj_to_type(parent, obj)
    parent.public_send(obj.to_s.underscore)
  end

  # def canvas_type
  #   if @item.mounting_type.present? && @item.mounting_type.name == "Framed"
  #     ["Canvas", "Canvas Board", "Textured Canvas", "Textured Canvas Board"]
  #   else
  #     ["Canvas", "Gallery Wrapped Canvas", "Stretched Canvas", "Canvas Board", "Textured Canvas", "Textured Canvas Board"]
  #   end
  # end

  # #authentication_type
  # def authentication_type
  #   ["Certificate of Authenticty", "Letter of Authenticty", "Certificate of Authenticty from Peter Max Studios", "none"] #PSA/BA, presented with...
  # end

  # def value_list(property)
  #   send(property)
  # end

  def set_value(value)
    if value != nil
      @item.properties["#{value}"]
    else
      nil
    end
  end

  # def items_format(item)
  #   artists = "#{item.artists_names} -" unless item.artists_names.nil?
  #   "#{artists} #{item.item_title} #{item.item_mounting_type} #{item.art_type} #{item.embellish_type} #{item.media_type} #{item.item_substrate_type} #{item.leafing_type} #{item.item_remarque} #{item.item_signature_type} #{item.item_certificate_type}. #{item.item_dimensions}"
  # end
  #
  # def items_tagline(item)
  #   artists = "#{item.artists_names} -" unless item.artists_names.nil?
  #   title = "\"#{item.item_title}\"" unless item.item_title.downcase == "untitled"
  #   if item.item_mounting_type != nil
  #     mounting = "#{item.item_mounting_type}" if item.item_mounting_type == "Framed"
  #   end
  #   media = "#{item.media_type}" if item.media_type != "Giclee"
  #   substrate = "on #{item.item_substrate_type}" unless item.item_substrate_type.nil? || item.item_substrate_type.split(" ").last == "Paper"
  #   "Tagline: #{artists} #{title} #{mounting} #{item.art_type} #{item.embellish_type} #{media} #{substrate}, #{item.leafing_type} #{item.item_remarque} #{item.item_signature_type} #{item.item_certificate_type}.".gsub(/ ,/, ',')
  # end
  #
  # def items_description(item)
  #   if item.art_type != nil
  #     if item.item_title == "Untitled"
  #       intro = item.art_type[0] =~ /\A[^aeiou]/ ? "This is a " : "This is an "
  #     else
  #       intro = item.art_type[0] =~ /\A[^aeiou]/ ? "\"#{item.item_title}\" is a " : "\"#{item.item_title}\" is an "
  #     end
  #   end
  #
  #   if item.art_type != nil
  #     art_type = item.item_mounting_type == "Framed" && item.properties["custom_framed"] != "1" ? "Framed #{item.art_type.downcase}" : item.art_type.downcase
  #   end
  #
  #   if item.properties != nil
  #     custom_framed = "This piece comes custom framed." if item.properties["custom_framed"] == "1"
  #   end
  #
  #   if item.properties != nil && item.signature_type != nil
  #     signature = "hand signed by the artist" if item.signature_type.name == "Signature"
  #   end
  #
  #   if item.properties != nil && item.certificate_type != nil
  #     certificate = "Includes Certificate of Authenticity." if item.certificate_type.name == "Authentication"
  #   end
  #
  #   media = "#{item.media_type}".downcase
  #   artists = "by #{item.artists_names}," unless item.artists_names.nil?
  #   title = "#{item.item_title}" unless item.item_title == "Untitled"
  #   mounting = "#{item.item_mounting_type}" if item.item_mounting_type == "Framed"
  #   substrate = "on #{item.item_substrate_type.downcase}" unless item.item_substrate_type.nil?
  #
  #   "Description: #{intro} #{art_type} #{item.embellish_type} #{media} #{substrate} #{item.leafing_type} #{artists} #{item.item_remarque} #{signature}. #{custom_framed} #{certificate} #{item.item_dimensions}.".gsub(/ ,/, ',')
  # end
end
