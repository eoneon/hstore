module DisclaimerTypesHelper
  def build_disclaimer(item)
    if item.properties["disclaimer_kind"].present? && item.properties["disclaimer"].present?
      title_disclaimer = item.properties["disclaimer_kind"] == "alert" ? "(Disclaimer)" : ""
      body_disclaimer = item.properties["disclaimer_kind"] == "alert" || item.properties["disclaimer_kind"] == "warning" ? "** Please note: #{item.properties["disclaimer"]} **" : "Please note: #{item.properties["disclaimer"]}"
      [title_disclaimer, body_disclaimer]
    else
      [""]
    end
  end
end
