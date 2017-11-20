module DimensionsHelper
  #these should be scopes inside the DimensionType model
  def flat_dimtype_list
    DimensionType.all.map {|dim| dim unless dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  def sculpture_dimtype_list
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

  def build_sculpture_dim(item, dims)
    dim_name(item).each do |dim|
      dims << "#{item.properties[dim]}\" (#{dim})"
    end
    "Measures approx. #{dims.join(" x ")}."
  end

  def build_dims(item)
    if dim_name(item).present?
      if dim_name(item)[-1] == "weight"
        [build_sculpture_dim(item, dims = [])]
      elsif dim_name(item)[-1] != "weight"
        image_dim = "#{item.properties["width"]}\" x #{item.properties["height"]}\""
        if dim_name(item).count == 1
          ["Measures approx. #{image_dim} (#{dim_name(item)[0]})."]
        elsif dim_name(item).count == 2
          ["Measures approx. #{item.properties["outer_width"]}\" x #{item.properties["outer_height"]}\" (#{dim_name(item)[-1]}); #{image_dim} (#{dim_name(item)[0]})."]
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
