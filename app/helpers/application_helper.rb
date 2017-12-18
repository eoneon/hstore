module ApplicationHelper
  #see rails cast 196
  def link_to_add_fields(name, f, association, parent)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{parent}/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def type_vl(parent)
    type_list = [ItemType, DimensionType, SubstrateType, EditionType, SignatureType, CertificateType, DisclaimerType]
    parent.invoice.present? && parent.invoice.name == "RR3" ? type_list.insert(-1, ReserveType) : type_list
  end

  def nil_parent_id_vl(parent)
    if parent.item_type_id.nil?
      type_vl(parent) - [EditionType, SubstrateType]
    end
  end

  def ltd_vl(parent)
    type_vl(parent) if parent.item_type_id.present? && parent.item_type.name == "limited edition"
  end

  def one_kind_vl(parent)
    type_vl(parent) if parent.item_type_id.present? && parent.item_type.name == "one-of-a-kind"
  end

  def sans_edition_vl(parent)
    type_vl(parent) - [EditionType] if parent.item_type_id.present? && parent.item_type.name == "print"
  end

  def sans_substrate_vl(parent)
    type_vl(parent) - [SubstrateType] if parent.item_type_id.present? && (parent.item_type.name == "limited edition sculpture" || parent.item_type.name == "limited edition sericel")
  end

  def sculpture_vl(parent)
    type_vl(parent) - [EditionType, SubstrateType] if parent.item_type_id.present? && parent.item_type.name == "sculpture"
  end

  def sans_edition_og_vl(parent)
    type_vl(parent) - [EditionType] if parent.item_type_id.present? && (parent.item_type.name == "original painting" || parent.item_type.name == "sketch")
  end


  def obj_type_list(parent)
    [nil_parent_id_vl(parent), ltd_vl(parent), sans_edition_vl(parent), sans_substrate_vl(parent), sculpture_vl(parent), sans_edition_og_vl(parent), one_kind_vl(parent)].reject {|m| m.blank?}[0]
  end

  def type_list(parent, type)
    if type == DimensionType && parent.item_type_id.present?
      if flat_art_list.include? parent.item_type_id
        flat_dimension_types
      elsif sculpture_list.include? parent.item_type_id
        sculpture_dimension_types
      end
    else
      type.all
    end
  end

  def obj_to_s(type)
    type.to_s.underscore
  end

  def obj_to_str(type)
    type.class.name.underscore
  end

  def obj_to_fk(type)
    type.to_s.underscore + "_id"
  end

  def obj_to_type(parent, type)
    parent.public_send(type.to_s.underscore)
  end

  def obj_to_type_id(parent, type)
    parent.public_send(type.to_s.underscore + "_id")
  end

  def set_value(value)
    if value != nil
      @item.properties["#{value}"]
    else
      nil
    end
  end

  def conditional_capitalize(words, *item)
    words = words.split(" ").reject {|word| word.blank?}
    if words.present?
      #1 find xl_image_dim/ xl_frame_dim
      #if [xl_image_dim(item), xl_frame_dim(item)].reject {|m| m.blank?}[0].present?
        #2 assign to var
        # xl_dims = [xl_image_dim(item), xl_frame_dim(item)].reject {|m| m.blank?}[0]
        #3 remove white space
        #xl_dims2 = [xl_image_dim(item), xl_frame_dim(item)].reject {|m| m.blank?}[0].gsub(/\s+/, "")
        #4 replace inside words
        #words.gsub(/xl_dims/, xl_dims2)

      clause = [words[0].downcase.capitalize!]
      words.shift
      words.each do |w|
        w = w.downcase.capitalize! unless reserved_list.any? { |word| w.downcase == word.downcase || /[0-9]/.match(w) || /-/.match(w).present? || w[0] == "(" }
        w = handle_hyphens(w) if /-/.match(w).present?
        w = handle_parenths(w) if w[0] == "(" && /[a-z]/.match(w[1])
        clause << w
      end
      #5 swap xl_dim values
      #
      clause.join(" ").gsub(/ ,/, ",")
    end
  end

  def handle_hyphens(hyphen_words)
    hyphen_arr = []
    hyphen_words.split("-").each do |hyphen_w|
      hyphen_w = hyphen_w.downcase.capitalize! unless reserved_list.any? { |word| hyphen_w == word }
      hyphen_arr << hyphen_w
    end
    hyphen_arr.join("-")
  end

  def handle_parenths(parenth_words)
    "(#{parenth_words[1..-1].downcase.capitalize!}"
  end

  def reserved_list
    ValueItem.where(kind: "edition_kind").pluck(:name) + ["a", "an", "of", "and", "or", "on", "with", "from", ",", "the", "i", "ii", "iii", "iv", "v", "vi", "PSA/DNA"]
  end
end
