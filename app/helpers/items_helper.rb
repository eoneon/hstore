module ItemsHelper
  def item_title(item)
    "\"#{conditional_capitalize(item.title)}\"" if item.title != "Untitled" && item.title.present?
  end

  def retail(item)
    number_to_currency(item.retail)
  end

  def tagline_intro(item)
    if artists(item)[0].present?
      "#{artists(item)[0]} - #{item_title(item)}"
    else
      "#{item_title(item)}"
    end
  end

  def description_intro(item, medium_description)
    if item.title == "Untitled"
      medium_description.first =~ /\A[^aeiou]/ ? "This is a " : "This is an"
    else
      medium_description.first =~ /\A[^aeiou]/ ? "#{item_title(item)} is a " : "#{item_title(item)} is an"
    end
  end

  def build_medium(item)
    medium = []
    media = item.properties.map { |k,v| medium << v if ["media"].any? { |m| k.include?(m)}}
    [[ item.properties["embellish_kind"], item.properties["limited_kind"], media, item.properties["sculpture_kind"]].join(" ").strip]
  end

  def build_medium2(item)
    medium2 = [ item.properties["leafing_kind"], item.properties["remarque_kind"] ].reject {|kind| kind.blank?}
    if medium2.count > 0
      medium2.count == 1 ? ["with #{medium2.join(" ")}"] : ["with #{medium2.join(" and ")}"]
    else
      [""]
    end
  end

  #medium comes from tagline/description
  def medium_ed_sign_cert(item, medium)
    certificate = build_certificate(item)[0] if build_certificate(item)[0].present?
    edition_signature_arr = [build_edition(item)[0], build_signature(item)[0]]
    arr_count = edition_signature_arr.reject {|v| v.blank?}.count
    if arr_count == 0
      medium = certificate.present? ? "#{medium} #{certificate}" : "#{medium}"
    else
      #"medium, <x> and <y>"
      if arr_count == 2
        edition_signature_arr = edition_signature_arr.join(" and ")
      elsif arr_count == 1 && certificate.blank?
        edition_signature_arr = edition_signature_arr[-1].blank? ? edition_signature_arr.reverse.join(" and ") : edition_signature_arr.join(" and ")
      elsif arr_count == 1 && certificate.present?
        edition_signature_arr = edition_signature_arr.join("")
      end
      medium = "#{medium}, #{edition_signature_arr} #{certificate}"
    end
  end

  #medium comes from tagline/description
  def medium_ed_sign(item, medium)
    edition_signature_arr = [build_edition(item)[0], build_signature(item)[-1]]
    arr_count = edition_signature_arr.reject {|v| v.blank?}.count
    if arr_count == 0
      "#{medium}"
    elsif arr_count == 2
      "#{medium}, #{edition_signature_arr.join(" and ")}"
    elsif arr_count == 1
      edition_signature_arr[-1].present? ? "#{medium}, #{edition_signature_arr[-1]}" : "#{medium}, and #{edition_signature_arr[0]}"
    end
  end

  def build_tagline(item)
    if item.properties.present?
      medium = [ build_framing(item)[0], build_medium(item)[0], build_substrate(item)[0], build_medium2(item)[0] ].join(" ").strip
      period = "." if medium.length > 0
      "#{tagline_intro(item)} #{conditional_capitalize(medium_ed_sign_cert(item, medium))}#{period}"
    end
  end

  def build_description(item)
    if item.properties.present?
      medium = [build_medium(item)[0], build_substrate(item)[-1], "#{artists(item)[-1]}", build_medium2(item)[-1]].join(" ").strip
      [description_intro(item, medium), "#{medium_ed_sign(item, medium)}.", build_framing(item)[-1], build_certificate(item)[-1], build_dims(item)[-1]].join(" ")
    end
  end
end
