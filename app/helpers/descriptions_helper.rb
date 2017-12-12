module DescriptionsHelper
  def tagline_intro(item)
    [artists(item)[0], item_title(item)].reject {|item| item.blank?}.join(" - ")
  end

  def reserve_title(item)
    intro = item_title(item).present? ? item_title(item) : "This"
    [reserve_clause(item)[-1], intro].reject {|item| item.blank?}.join(" ")
  end

  def description_intro(item, medium)
    if medium.present?
      medium.split(" ")[0] == "one-of-a-kind" || medium.split(" ")[0].first =~ /\A[^aeiou]/ ? ["#{reserve_title(item)}", "is a"].join(" ") : ["#{reserve_title(item)}", "is an"].join(" ")
    end
  end

  def intro(item, medium)
    [tagline_intro(item), description_intro(item, medium)]
  end

  #change name to description_title; include substrate values: "on stretched canvas" "on paper" using a gsub loop? then remove for case specific reasons
  #not sure about this one but it seems like I could also use this for :medium in :description_body
  #I could also include :conditional_capitalize and a method to remove "  " using gsub or strip.

  #medium
  def build_title(item)
    if item.properties.present?
      medium = [ build_medium(item)[0], build_substrate(item)[0], build_medium2(item)[0] ].join(" ").squish!
      period = "." if medium.length > 0
      #"#{intro(item, medium)[0]} #{conditional_capitalize(medium_ed_sign_cert(item, medium))}#{period}"
      ["#{conditional_capitalize(medium_ed_sign_cert(item, medium))}#{period}".squish!, "#{intro(item, medium)[0]} #{conditional_capitalize(medium_ed_sign_cert(item, medium))}#{period}".squish!]
    end
  end

  def tagline(item)
    if item.properties.present?
      [build_title(item)[-1], reserve_clause(item)[0], build_disclaimer(item)[0]].join(" ").split(" ").reject {|word| word.downcase == "giclee" || word.downcase == "stretched"}.join(" ") #.delete(" giclee ", " stretched ")
    end
  end

  def prop_room(item)
    if item.properties.present?
      d = [build_title(item)[-1], retail(item), build_disclaimer(item)[0]].join(" ").squish
      abbrv_description(d, item, 128)
    end
  end

  def inv_tagline(item)
    if item.properties.present?
      d = build_title(item)[0]
      abbrv_description(d, item, 100)
    end
  end

  def build_description(item)
    if item.properties.present?
      medium = [build_medium(item)[0], build_substrate(item)[-1], "#{artists(item)[-1]}", build_medium2(item)[-1]].join(" ").strip
      # [reserve_clause(item)[-1], description_intro(item, medium), "#{medium_ed_sign(item, medium)}.", build_framing(item)[-1], build_certificate(item)[-1], build_dims(item)[-1]].join(" ").squish
      [intro(item, medium)[-1], "#{medium_ed_sign(item, medium)}.", build_framing(item)[-1], build_certificate(item)[-1], build_dims(item)[-1], build_disclaimer(item)[-1]].join(" ").squish
    end
  end

  def abbrv_description(d, item, limit)
    sub_list(item).each do |sub_arr|
      return d if d.size <= limit
      d = d.gsub(/#{sub_arr[0]}/i, "#{sub_arr[-1]}")
    end
    d
  end

  def sub_list(item)
    [
      [" List", ""], [coa(item), authentication(item)], [" Limited Edition ", " Ltd Ed "], [" - ", "-"],
      [" Numbered ", " No. "], ["Certificate", "Cert"], ["Gold Leaf", "GoldLeaf"], ["Silver Leaf", "SilverLeaf"],
      [" with ", " w/"], [xy_numbering(item), ""], [out_of_an_edition_size(item), ""], [artists_target(item)[0], artists_abrv(item)[-1]],
      [" and ", " & "],
      ["Hand Drawn Remarque", "Remarque"], ["Hand Embellished", "Embellished"], ["Artist Embellished", "Embellished"]

    ].reject { |sub_arr| sub_arr.join("").empty?}
  end
end
