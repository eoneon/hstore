module SubstrateTypesHelper
  def build_substrate(item)
    substrate_kind = nil
    item.properties.keys.map {|k| substrate_kind = k if k == "canvas_kind" || k == "paper_kind" || k == "other_kind"}
    if substrate_kind.present?
      substrate_kind != "paper_kind" ? [ "on #{item.properties[substrate_kind].gsub(/stretched/i, "")}",  "on #{item.properties[substrate_kind]}"] : ["","on #{item.properties[substrate_kind]}" ]
    else
      [""]
    end
  end

  def build_substrate_inv(item)
    substrate_kind = nil
    item.properties.keys.map {|k| substrate_kind = k if k == "canvas_kind" || k == "paper_kind" || k == "other_kind"}
    if substrate_kind.present?
      "on #{item.properties[substrate_kind]}"
    else
      [""]
    end
  end
end
