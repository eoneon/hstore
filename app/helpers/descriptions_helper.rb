module DescriptionsHelper
  def tagline_intro(item)
    artists(item)[0].present? ? "#{artists(item)[0]} - #{item_title(item)}" : "#{item_title(item)}"
  end

  def description_intro(item, medium)
    title = item_title(item).present? ? item_title(item) : "This"
    if medium.present?
      medium.split(" ")[0] == "one-of-a-kind" || medium.split(" ")[0].first =~ /\A[^aeiou]/ ? ["#{title}", "is a"].join(" ") : ["#{title}", "is an"].join(" ")
    end
  end

  #change name to description_title; include substrate values: "on stretched canvas" "on paper" using a gsub loop? then remove for case specific reasons
  #not sure about this one but it seems like I could also use this for :medium in :description_body
  #I could also include :conditional_capitalize and a method to remove "  " using gsub or strip.
  def build_tagline(item)
    if item.properties.present?
      medium = [ build_framing(item)[0], build_medium(item)[0], build_substrate(item)[0], build_medium2(item)[0] ].join(" ").strip
      period = "." if medium.length > 0
      "#{tagline_intro(item)} #{conditional_capitalize(medium_ed_sign_cert(item, medium))}#{period}".squish
    end
  end

  def build_description_inv(item)
    if item.properties.present?
      medium = [ build_framing(item)[0], build_medium(item)[0], build_substrate_inv(item), build_medium2(item)[0] ].join(" ").strip
      period = "." if medium.length > 0
      "#{conditional_capitalize(medium_ed_sign_cert(item, medium))}#{period}"
    end
  end

  def build_description(item)
    if item.properties.present?
      medium = [build_medium(item)[0], build_substrate(item)[-1], "#{artists(item)[-1]}", build_medium2(item)[-1]].join(" ").strip
      [description_intro(item, medium), "#{medium_ed_sign(item, medium)}.", build_framing(item)[-1], build_certificate(item)[-1], build_dims(item)[-1]].join(" ").squish
    end
  end

  def sub_list(item)
    [
      ["  ", " "], [" List", ""], [coa(item), authentication(item)], [" Limited Edition ", " Ltd Ed "], [" - ", "-"],
      [" Numbered ", " No. "], ["Certificate", "Cert"], ["Gold Leaf", "GoldLeaf"], ["Silver Leaf", "SilverLeaf"],
      [" with ", " w/"], [xy_numbering(item), ""], [out_of_numbering(item), ""], [artists_target(item)[0], artists_abrv(item)[-1]],
      [" and ", " & "],
      ["Hand Drawn Remarque", "Remarque"], ["Hand Embellished", "Embellished"], ["Artist Embellished", "Embellished"]

    ].reject { |sub_arr| sub_arr.join("").empty?}
  end

  def descripton_pr(item)
    d = [build_tagline(item), retail(item)].join(" ")
    sub_list(item).each do |sub_arr|
      return d if d.size <= 128
      d = d.gsub(/#{sub_arr[0]}/i, "#{sub_arr[-1]}")
    end
    d
  end

  def abbr_description(item)
    d = build_description_inv(item)
    sub_list(item).each do |sub_arr|
      return d if d.size <= 100
      d = d.gsub(/#{sub_arr[0]}/i, "#{sub_arr[-1]}")
    end
    d
  end
end
