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

  def obj_type_list(parent)
    type_list = [ItemType, EditionType, SubstrateType, DimensionType, SignatureType,  CertificateType]
    if parent.item_type_id.nil?
      type_list - [EditionType, SubstrateType]
    else
      if parent.item_type.name == "limited edition"
        type_list
      elsif parent.item_type.name == "print"
        type_list - [EditionType]
      elsif parent.item_type.name == "limited edition sculpture" || parent.item_type.name == "limited edition sericel"
        type_list - [SubstrateType]
      elsif parent.item_type.name == "sculpture"
        type_list - [EditionType, SubstrateType]
      elsif parent.item_type.name == "one-of-a-kind"
        type_list
      elsif parent.item_type.name == "original painting" || parent.item_type.name == "sketch"
        type_list - [EditionType]
      end
    end
  end

  # def obj_type_list(parent)
  #   type_list = type_list(parent)
  #   if parent.item_type.name == "limited edition"
  #     type_list
  #   elsif parent.item_type.name == "print"
  #     type_list - [EditionType]
  #   elsif parent.item_type.name == "limited edition sculpture" || parent.item_type.name == "limited edition sericel"
  #     type_list - [SubstrateType]
  #   elsif parent.item_type.name == "sculpture"
  #     type_list - [EditionType, SubstrateType]
  #   elsif parent.item_type.name == "one-of-a-kind"
  #     type_list
  #   elsif parent.item_type.name == "original painting" || parent.item_type.name == "sketch"
  #     type_list - [EditionType]
  #   end
  # end

  # def type_list(parent)
  #   if parent.item_type_id.present?
  #     #if flat art -> exclude sculpture dimensions
  #     if flat_item_list.include? parent.item_type_id
  #     list.map {|type| type == DimensionType ? flat_item_list : type}
  #   #sculpture -> exclude flat art dimensions
  #   elsif sculpture_item_list.include? parent.item_type_id
  #     list.map {|type| type == DimensionType ? sculpture_item_list : type}
  #   end
  # end

  def type_list(parent, type)
    if type == DimensionType && parent.dimension_type_id.present?
      #if flat art and loop type is dimension type -> exclude sculpture dimensions
      if flat_item_list.include? parent.item_type_id
        flat_dimtype_list
      #sculpture -> exclude flat art dimensions
      elsif sculpture_item_list.include? parent.item_type_id
        sculpture_dimtype_list
      end
    else
      type.all
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

  def retail(parent)
    parent.retail
  end

  def set_value(value)
    if value != nil
      @item.properties["#{value}"]
    else
      nil
    end
  end
end
