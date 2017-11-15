module EditionTypesHelper
  # def build_edition(item)
  #   if item.properties["limited_kind"].present? && item.edition_type.present?
  #     if item.edition_type.name == "x/y"
  #       #numbered = numbered(item)
  #       numbered = [item.properties["edition_kind"], "numbered"].join(" ").strip
  #       if item.properties["number"].present? && item.properties["edition_size"].present?
  #         #numbering = numbering(item)
  #         numbering = ["#{numbered} #{item.properties["number"]}/#{item.properties["edition_size"]}"]
  #       elsif item.properties["number"].blank? && item.properties["edition_size"].present?
  #         numbering = ["#{numbered} out of #{item.properties["edition_size"]}"]
  #       elsif (item.properties["number"].blank? && item.properties["edition_size"].blank?) || (item.properties["number"].present? && item.properties["edition_size"].blank?)
  #         numbering = [numbered]
  #       end
  #     else
  #       numbering = ["from a #{item.properties["edition_kind"]} edition"]
  #     end
  #   else
  #     [""]
  #   end
  # end

  ####start here
  #[AP, numbered]
  def edition_kind_numbered(item)
    [item.properties["edition_kind"], "numbered"].join(" ").strip
  end

  def num_arr(item)
    [item.properties["number"], item.properties["edition_size"]]
  end

  def num_count(item)
    num_arr(item).count {|n| n.present?}
  end

  def xy_numbering(item)
    if num_count(item) == 2
      num_arr(item).join("/")
    end
  end

  def out_of_numbering(item)
    if num_count(item) == 1 && num_arr(item)[-1].present?
      "out of #{num_arr(item)[-1]}"
    end
  end

  def from_an_edition(item)
    "from a #{item.properties["edition_kind"]} edition"
  end

  def build_edition(item)
    if item.properties["limited_kind"].present? && item.edition_type.present?
      if item.edition_type.name == "x/y"
        [[edition_kind_numbered(item), xy_numbering(item), out_of_numbering(item)].reject {|v| v.blank?}.join(" ")]
      elsif item.edition_type.name == "edition only"
        [from_an_edition(item)]
      end
    else
      [""]
    end
  end
end
