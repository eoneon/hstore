module MediumsHelper
  def build_medium(item)
    medium = []
    media = item.properties.map { |k,v| medium << v if v.present? && ["media"].any? { |m| k.include?(m)}}
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
    medium = [ build_framing(item)[0], medium, build_edition(item)[0] ].join(" ")
    edition_signature = [build_edition(item)[1], build_signature(item)[0] ].reject {|item| item.blank?}.join(" and ")
    [ [ medium, edition_signature].reject {|item| item.blank?}.join(", "), build_certificate(item)[0] ].join(" ").squish
  end

  #medium comes from tagline/description
  def medium_ed_sign(item, medium)
    edition_signature = [build_edition(item)[1], build_signature(item)[-1] ].reject {|item| item.blank?}.join(" and ")
    [ medium, edition_signature].reject {|item| item.blank?}.join(", ")
  end
end
