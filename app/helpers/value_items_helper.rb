module ValueItemsHelper
  def value_list(parent, field_name)
    if field_name == "canvas_kind" && dim_arr(parent) == "frame"
      ValueItem.where(kind: field_name).order(:sort).pluck(:name) - ["stretched canvas", "gallery wrapped canvas"]
    else
      ValueItem.where(kind: field_name).order(:sort).pluck(:name)
    end
  end
end
