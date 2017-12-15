module DimensionsHelper
  #these should be scopes inside the DimensionType model/flat_dimtype_list
  def flat_dimension_types
    DimensionType.all.map {|dim| dim unless dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  def sculpture_dimension_types
    DimensionType.all.map {|dim| dim if dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  #we can get rid of these at some point since they're inside item and here
  #also, the above methods should cover those below.
  def dim_name(item)
    item.dimension_type.name.split(" & ") if item.dimension_type.present?
  end

  def dim_arr(item)
    dim_name(item)[-1] if item.dimension_type.present?
  end

  def image_size(item)
    if item.properties?
      item.properties["width"].to_f * item.properties["height"].to_f
    end
  end

  def sculpture_w_h(item)
    if dim_name(item)[-1] == "weight"
      [item.properties[dim_name(item)[0]], item.properties[dim_name(item)[-1]]]
    end
  end

  def flat_w_h(item)
    if dim_name(item)[-1] != "weight"
      [item.properties["width"], item.properties["height"], item.properties["outer_width"], item.properties["outer_height"]].reject {|v| v.blank?}
    end
  end

  def width_height(item)
    if dim_name(item).present?
      [sculpture_w_h(item), flat_w_h(item)].reject {|v| v.blank?}[0]
    else
      [""]
    end
  end

  def build_sculpture_dim(item, dims)
    dim_name(item).each do |dim|
      if item.properties[dim].present?
        #dim_sym = dim != "weight" ? "\"" : "lbs."
        #dims << "#{item.properties[dim]}#{dim_sym} (#{dim})"
        dims << "#{item.properties[dim]} (#{dim})" unless dim == "weight"
      end
    end
    dims = item.properties["weight"].present? ? "#{dims.join(" x ")}; #{item.properties["weight"]}lbs. (weight)" : "#{dims.join(" x ")}"
    "Measures approx. #{dims}."
    #{}"Measures approx. #{dims.join(" x ")}."
  end

  def build_dims(item)
    if dim_name(item).present?
      if dim_name(item)[-1] == "weight"
        [build_sculpture_dim(item, dims = [])]
      elsif dim_name(item)[-1] != "weight"
        image_dim = "#{item.properties["width"]}\" x #{item.properties["height"]}\"" #if item.properties["width"].present? && item.properties["height"].present?
        outer_dim = "#{item.properties["outer_width"]}\" x #{item.properties["outer_height"]}\""
        if dim_name(item).count == 1
          ["Measures approx. #{image_dim} (#{dim_name(item)[0]})."]
        elsif dim_name(item).count == 2
          #["Measures approx. #{item.properties["outer_width"]}\" x #{item.properties["outer_height"]}\" (#{dim_name(item)[-1]}); #{image_dim} (#{dim_name(item)[0]})."]
          ["Measures approx. #{outer_dim} (#{dim_name(item)[-1]}); #{image_dim} (#{dim_name(item)[0]})."]
        end
      end
    else
      [""]
    end
  end

  def build_framing(item)
    if item.dimension_type.present? && item.properties["frame_kind"].present?
      ["Framed", "This piece is #{item.properties["frame_kind"]}."]
    else
      [""]
    end
  end
end
