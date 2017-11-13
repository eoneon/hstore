module EditionTypesHelper
  def build_edition(item)
    if item.properties["limited_kind"].present? && item.edition_type.present?
      if item.edition_type.name == "x/y"
        numbered = [item.properties["edition_kind"], "numbered"].join(" ").strip
        if item.properties["number"].present? && item.properties["edition_size"].present?
          numbering = ["#{numbered} #{item.properties["number"]}/#{item.properties["edition_size"]}"]
        elsif item.properties["number"].blank? && item.properties["edition_size"].present?
          numbering = ["#{numbered} out of #{item.properties["edition_size"]}"]
        elsif item.properties["number"].blank? && item.properties["edition_size"].blank?
          numbering = [numbered]
        end
      else
        numbering = ["numbered from a #{item.properties["edition_kind"]} edition"]
      end
    else
      [""]
    end
  end
end
