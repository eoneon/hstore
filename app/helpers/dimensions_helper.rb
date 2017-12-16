module DimensionsHelper
  #these should be scopes inside the DimensionType model/flat_dimtype_list
  def flat_dimension_types
    DimensionType.all.map {|dim| dim unless dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  def sculpture_dimension_types
    DimensionType.all.map {|dim| dim if dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  # def sorted_dimension_names
  #   [DimensionType.all.map {|dim| dim if dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?},
  #   DimensionType.all.map {|dim| dim unless dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}]
  # end

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

  def frame_size(item)
    if item.properties? && dim_name(item)[-1] == "frame"
      item.properties["outer_width"].to_f * item.properties["outer_height"].to_f
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
    if dim_name(item).present? && item.properties["width"].present? && item.properties["height"].present?
      [sculpture_w_h(item), flat_w_h(item)].reject {|v| v.blank?}[0]
    else
      [""]
    end
  end

  def build_sculpture_dim(item, dims)
    if dim_name(item)[-1] == "weight"
      dim_name(item).each do |dim|
        if item.properties[dim].present?
          dims << "#{item.properties[dim]} (#{dim})" unless dim == "weight"
        end
      end
      item.properties["weight"].present? ? "#{dims.join(" x ")}; #{item.properties["weight"]}lbs. (weight)." : "#{dims.join(" x ")}."
    end
  end


  def xl_image_dim(item)
    if image_size(item) >= 864 && dim_name(item)[-1] == "image"
      "(#{item.properties["width"]}\" x #{item.properties["height"]}\")"
    end
  end

  def xl_frame_dim(item)
    if dim_name(item)[-1] == "frame" && frame_size(item) >= 864
      "(#{item.properties["outer_width"]}\" x #{item.properties["outer_height"]}\")"
    end
  end

  def xl_dim(item)
    [xl_image_dim(item), xl_frame_dim(item)].reject {|m| m.blank?}.join(" ")
  end

  def image_dim_name(item)
    if item.properties["width"].present? && item.properties["height"].present? && dim_name(item)[-1] != "weight"
      "#{item.properties["width"]}\" x #{item.properties["height"]}\" (#{dim_name(item)[0]})."
    end
  end

  def outer_dim_name(item)
    if item.properties["outer_width"].present? && item.properties["outer_height"].present? && dim_name(item)[-1] != "weight"
      "#{item.properties["outer_width"]}\" x #{item.properties["outer_height"]}\" (#{dim_name(item)[1]});"
    end
  end

  def build_dims(item)
    if dim_name(item).present?
      [["Measures approx.", outer_dim_name(item), image_dim_name(item),[build_sculpture_dim(item, dims = [])].join(" ")].reject {|m| m.blank?}.join(" ")]
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
