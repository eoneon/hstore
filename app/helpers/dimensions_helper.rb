module DimensionsHelper
  #these should be scopes inside the DimensionType model
  def flat_dim_list
    DimensionType.all.map {|dim| dim unless dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  def sculpture_dim_list
    DimensionType.all.map {|dim| dim if dim.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  #we can get rid of these at some point since they're inside item and here
  #also, the above methods should cover those below.
  def dim_name(parent)
    parent.dimension_type.name.split(" & ") if parent.dimension_type.present?
  end

  def dim_arr(parent)
    dim_name(parent)[-1] if parent.dimension_type.present?
  end
end
