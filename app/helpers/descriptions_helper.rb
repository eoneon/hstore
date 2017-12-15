module DescriptionsHelper
  def tagline_intro(item)
    ["#{artists(item)[0]} -", item_title(item)].reject {|item| item.blank?}.join(" ")
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

  #medium
  def build_title(item)
    if item.properties.present?
      medium = [ build_medium(item)[0], build_substrate(item)[0], xl_dim(item), build_medium2(item)[0] ].join(" ").squish!
      period = "." if medium.length > 0
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
      medium = [build_medium(item)[0], build_substrate(item)[-1], build_edition(item)[0], artists(item)[-1], build_medium2(item)[-1]].join(" ").squish
      [intro(item, medium)[-1], "#{medium_ed_sign(item, medium)}.", build_framing(item)[-1], not_numbered(item)[0], seal(item), missing_cert_clause(item), build_certificate(item)[-1], build_dims(item)[-1], build_disclaimer(item)[-1]].join(" ").squish
    end
  end

  def abbrv_description(d, item, limit)
    sub_list(item).each do |sub_arr|
      return d.squish! if d.squish.size <= limit
      d = d.gsub(/#{sub_arr[0]}/i, "#{sub_arr[-1]}").squish!
    end
    d
  end

  def sub_list(item)
    [
      [" List", ""], [" Limited Edition", " Ltd Ed "], [" - ", "-"],
      ["Certificate of Authenticity", "Certificate"], ["Certificate", "Cert"], ["Letter of Authenticity", "LOA"], ["Gold Leaf", "GoldLeaf"],
      ["Silver Leaf", "SilverLeaf"], [" with ", " w/"], [" Numbered ", " No. "], [xy_numbering(item), ""], [out_of_an_edition_size(item), ""], [artists_target(item)[0], artists_abrv(item)[-1]],
      [" and ", " & "], ["Hand Drawn Remarque", "Remarque"], ["Hand Embellished", "Embellished"], ["Artist Embellished", "Embellished"]

    ].reject { |sub_arr| sub_arr.join("").empty?} #[coa(item), authentication(item)]
  end
end
