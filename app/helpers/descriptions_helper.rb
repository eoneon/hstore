module DescriptionsHelper
  def tagline_intro(item)
    artists(item)[0].present? ? "#{artists(item)[0]} - #{item_title(item)}" : "#{item_title(item)}"
  end

  def description_intro(item, medium)
    title = item_title(item).present? ? item_title(item) : "This"
    medium.split(" ")[0] == "one-of-a-kind" || medium.split(" ")[0].first =~ /\A[^aeiou]/ ? ["#{title}", "is a"].join(" ") : ["#{title}", "is an"].join(" ")
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

  def sub_list(item)
    [
      [" List ", ""], [coa(item), authentication(item)], [" Limited Edition ", " Ltd Ed "], [" Numbered ", " No. "],
      ["Certificate", "Cert"], [" with ", " w/"], [xy_numbering(item), ""], [out_of_numbering(item), ""], [" and ", " & "]
    ].reject { |sub_arr| sub_arr.join("").empty?}
  end

  # def descripton_pr(item)
  #   d = [build_tagline(item), retail(item)].join(" ")
  #   if d.size <= 128
  #     d
  #   else
  #     i = 0
  #     while d.size >= 128 || i <= sub_list(item).count - 1 do
  #       #would need to convert sub_list(item)[i][0] to a regexp if possible
  #       d.gsub(/"#{sub_list(item)[i][0]}"/"#{sub_list(item)[i][-1]}")
  #       i + 1
  #     end
  #   end
  # end
  #this works BUT it will pick up
  def descripton_pr(item)
    d = [build_tagline(item), retail(item)].join(" ")
    if d.size <= 128
      d
    else
      sub_list(item).each do |sub_arr|
        d = d.gsub(/#{sub_arr[0]}/i, "#{sub_arr[-1]}")
        return d if d.size <= 128
      end
    end
    d
  end
end
