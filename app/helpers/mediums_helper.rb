module MediumsHelper
  def build_medium(item)
    medium = []
    media = item.properties.map { |k,v| medium << v if v.present? && ["media"].any? { |m| k.include?(m)}}
    [[ build_framing(item)[0], item.properties["embellish_kind"], item.properties["limited_kind"], media, item.properties["sculpture_kind"]].join(" ").strip]
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
    medium = [build_framing(item)[0], medium.gsub(/giclee/, "")].join(" ")
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
end
