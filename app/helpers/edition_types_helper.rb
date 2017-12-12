module EditionTypesHelper
  #e.g., "AP numbered" -> don't capture unless "x/y"
  def edition_kind_numbered(item)
    [item.properties["edition_kind"], "numbered"].join(" ").strip if item.edition_type.name == "x/y"
  end

  #e.g., [1, 10]
  def xy_arr(item)

    [item.properties["number"], item.properties["edition_size"]]
  end

  def num_count(item)
    xy_arr(item).count {|n| n.present?}
  end

  #e.g., "1/10"
  def xy_numbering(item)
    if item.properties && num_count(item) == 2
      xy_arr(item).join("/")
    end
  end

  #e.g., "from an edition of 2000" -> "this piece is not numbered..."
  def from_an_edition_size(item)
    if item.properties && item.edition_type.present?
      "from an edition of #{item.properties["edition_size"]}" if item.edition_type.name == "from edition size" && item.properties["edition_size"].present?
    end
  end

  #e.g., "numbered out of 200"
  def out_of_an_edition_size(item)
    if item.properties && item.edition_type.present?
      "out of #{xy_arr(item)[1]}" if item.edition_type.name == "x/y" && num_count(item) == 1 && xy_arr(item)[1].present?
    end
  end

  #e.g., "from an AP edition"
  def from_an_edition_kind(item)
    if item.properties["edition_kind"].present? && item.edition_type.name == "edition only"
      conj = item.properties["edition_kind"][0].downcase =~ /\A[^aeiou]/ ? "a" : "an"
      "from #{conj} #{item.properties["edition_kind"]} edition"
    end
  end

  def build_edition(item)
    if item.properties["limited_kind"].present? && item.edition_type.name.present?
      [[from_an_edition_size(item), from_an_edition_kind(item)].reject {|v| v.blank?}, [edition_kind_numbered(item), out_of_an_edition_size(item), xy_numbering(item)].reject {|v| v.blank?}.join(" ")]
    else
      [""]
    end
  end

  def not_numbered(item)
    if from_an_edition_size(item).present?
      ["This piece is not numbered."]
    else
      [""]
    end
  end
end
