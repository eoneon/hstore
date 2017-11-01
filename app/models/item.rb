class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :dimension_type
  belongs_to :edition_type
  belongs_to :leafing_type
  belongs_to :remarque_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type
  belongs_to :invoice

  has_many :artist_items, dependent: :destroy
  has_many :artists, through: :artist_items, dependent: :destroy
  delegate :first_name, :last_name, :to => :artist

  before_save :set_title #:set_art_type, :set_category

  def set_title
    self.title = "Untitled" if self.title.blank?
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    #create unless already exists
    item = find_by_id(row["id"]) || new
    #don't update id fields
    item.attributes = row.to_hash
    item.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def capitalize_words(str)
    str.split.map { |word| word.downcase.capitalize! }.join(" ")
  end

  def item_title
    "\"#{capitalize_words(self.title)}\"" if self.title != "Untitled" && self.title.present?
  end

  def artists
    artists = self.artist_ids.map { |a| Artist.find(a).full_name }
    artists.present? ? [artists.join(" and "), "by #{artists.join(" and ")}"] : [""]
  end

  def description_intro(medium_description)
    if self.title == "Untitled"
      medium_description.first =~ /\A[^aeiou]/ ? "This is a " : "This is an "
    else
      medium_description.first =~ /\A[^aeiou]/ ? "#{item_title} is a " : "#{item_title} is an "
    end
  end

  def tagline_intro
    if artists[0].present?
      "#{artists[0]} - #{item_title}"
    else
      "#{item_title}"
    end
  end

  #medium methods
  def sculpture_description(v2, medium_tag, medium_description)
    medium_tag << v2
    medium_description << v2
  end

  def flat_tag(obj_values, k2, v2, substrate_kind, medium_tag)
    if ["media"].any? { |word| k2.include?(word) }
      #next if
      if v2 == "giclee" && substrate_kind == "paper_kind"
        v2 = nil
      elsif v2 != "giclee" && substrate_kind != "paper_kind"
        v2 = "#{v2} on #{obj_values["substrate_type"][substrate_kind]}"
      elsif v2 == "giclee" && substrate_kind != "paper_kind"
        v2 = "on #{obj_values["substrate_type"][substrate_kind]}"
      end
    elsif k2 == "leafing_kind"
      v2 = "with #{v2}"
    elsif k2 == "remarque_kind"
      v2 = obj_values["item_type"]["leafing_kind"].present? ? "and #{v2}" : "with #{v2}"
    end
    medium_tag << v2
  end

  def flat_description(obj_values, k2, v2, substrate_kind, medium_description)
    #both: add substrate after media ["ink_media", "sketch_media", "print_media"]
    if ["media"].any? { |word| k2.include?(word) } #"paint_media", "mixed_media", "ink_media", "sketch_media", "print_media"
      v2 = "#{v2} on #{obj_values["substrate_type"][substrate_kind]}" unless obj_values["substrate_type"][substrate_kind] == ""
    elsif k2 == "leafing_kind"
      v2 = "with #{v2}"
    elsif k2 == "remarque_kind"
      v2 = obj_values["item_type"]["leafing_kind"].present? ? "and #{v2}" : "with #{v2}"
    end
    medium_description << v2
  end

  def format_sculpture_dimensions(name_to_a, obj_values, measurements)
    name_to_a.each do |dim|
      measurements << "#{obj_values["dimension_type"][dim]}\" (#{dim})"
    end
  end

  def format_values(obj_values)
    obj_values.each do |k, v|
      if k == "item_type"
        medium_tag = []
        medium_description = []
        v.each do |k2, v2|
          next if k2 == "item_name" || v2.blank?
          #building medium: flat art specific conditions
          #replace with art_type method
          if obj_values["dimension_type"].present? && obj_values["dimension_type"]["dimension_name"].split(" & ").last == "weight"
            sculpture_description(v2, medium_tag, medium_description)
          elsif obj_values["substrate_type"].present?
            #^could this be used universally to distinguish betsween scuputure/flat art?
            substrate_kind = "#{obj_values["substrate_type"]["substrate_name"]}_kind"
            #substrate_kind = obj_values["substrate_type"]["paper_kind"]
            #difference between tag/description: giclee, paper, punctuation.
            flat_tag(obj_values, k2, v2, substrate_kind, medium_tag) if substrate_kind.present?
            flat_description(obj_values, k2, v2, substrate_kind, medium_description)
          end
        end
        obj_values["tagline_hash"]["medium_tag"] = "#{medium_tag.join(" ")}"
        obj_values["description_hash"]["medium_description"] = "#{description_intro(medium_description)} #{medium_description.join(" ")}"
        obj_values["tagline_hash"]["intro"] = tagline_intro
        obj_values["description_hash"]["artists"] = "by #{artists}" if artists.present?

      elsif k == "dimension_type"
        #replace with art_type method
        name_to_a = obj_values[k]["dimension_name"].split(" & ")
        if name_to_a[-1] == "weight"
          measurements = []
          format_sculpture_dimensions(name_to_a, obj_values, measurements)
          measurements = "Measures approx. #{measurements.join(" x ")}."
        else
          image_dim = "#{obj_values[k]["width"]}\" x #{obj_values[k]["height"]}\""
          #replace with art_type method?
          if name_to_a[0] == name_to_a[-1] #image only
            measurements = "Measures approx. #{image_dim} (#{name_to_a[0]})."
          else
            measurements = "Measures approx. #{obj_values[k]["outer_width"]}\" x #{obj_values[k]["outer_height"]}\" (#{name_to_a[-1]}); #{image_dim} (#{name_to_a[0]})."
            if name_to_a[-1] == "frame"
              obj_values["description_hash"]["framing"] = "This piece is #{obj_values[k]["frame_kind"]}."
              obj_values["tagline_hash"]["framing"] = "Framed"
            end
          end
        end
        obj_values["description_hash"]["measurements"] = measurements
        # obj_values["tagline_hash"]["image_dim"] if large...

      elsif k == "edition_type"
        if obj_values[k]["edition_name"] == "x/y"
          numbered = obj_values[k]["edition_kind"].present? ? "#{obj_values[k]["edition_kind"]} numbered" : "numbered"
          if obj_values[k]["number"].present? && obj_values[k]["edition_size"].present?
            numbering = "#{numbered} #{obj_values[k]["number"]}/#{obj_values[k]["edition_size"]}"
          elsif obj_values[k]["number"].blank? && obj_values[k]["edition_size"].present?
            numbering = "#{numbered} out of #{obj_values[k]["edition_size"]}"
          elsif obj_values[k]["number"].blank? && obj_values[k]["edition_size"].blank?
            numbering = numbered
          end
        else
          numbering = "numbered from a #{obj_values[k]["edition_kind"]} edition"
        end
        obj_values["description_hash"]["numbering"] = numbering
        obj_values["tagline_hash"]["numbering"] = numbering

      elsif k == "signature_type" && obj_values[k]["signature_kind"].present?
        if obj_values[k]["signature_kind"] == "unsigned"
          obj_values["description_hash"]["signature"] = "This piece is not signed."
        elsif obj_values[k]["signature_kind"] != "unsigned"
          if obj_values[k]["signature_kind"] == "hand signed" || obj_values[k]["signature_kind"] == "hand signed and thumb printed"
            signature_tag = "#{obj_values[k]["signature_kind"]}"
            signature_description = "#{signature_tag} by the artist"
          elsif obj_values[k]["signature_kind"] == "plate signature" || obj_values[k]["signature_kind"] == "authorized signature"
            signature_tag = "signed"
            signature_description = "bearing the #{obj_values[k]["signature_kind"]} of the artist"
          elsif obj_values[k]["signature_kind"] == "autographed"
            signature_tag = "#{obj_values[k]["signature_kind"]} by #{artists}"
            signature_description = signature_tag
          end
          obj_values["tagline_hash"]["signature"] = signature_tag
          obj_values["description_hash"]["signature"] = signature_description
        end

      elsif k == "certificate_type" && (obj_values[k]["certificate_kind"].present? || obj_values[k]["issuer"].present?)
        if obj_values[k]["certificate_name"] == "general certificate"
          obj_values["tagline_hash"]["certificate"] = "with #{obj_values[k]["certificate_kind"]}"
          obj_values["description_hash"]["certificate"] = "Includes #{conditional_capitalize(obj_values[k]["certificate_kind"])}."
        elsif obj_values[k]["certificate_name"] == "issued certificate"
          obj_values["tagline_hash"]["certificate"] = "with Certificate of Authenticity from #{obj_values[k]["issuer"]}"
          obj_values["description_hash"]["certificate"] = "Includes Certificate of Authenticity from #{obj_values[k]["issuer"]}"
        end
      end
      #^end of k == _type conditions
    end
  end

  def reserved_list
    ValueItem.where(kind: "edition_kind").pluck(:name) + ["a", "of", "and", "or", "on", "with", "from", ","]
  end

  def handle_hyphens(hyphen_words)
    hyphen_arr = []
    hyphen_words.split("-").each do |hyphen_w|
      hyphen_w = hyphen_w.downcase.capitalize! unless reserved_list.any? { |word| hyphen_w == word }
      hyphen_arr << hyphen_w
    end
    hyphen_arr.join("-")
  end

  def conditional_capitalize(words)
    tagline = []
    words.split.each do |w|
      w = w.downcase.capitalize! unless reserved_list.any? { |word| w == word || /[0-9]/.match(w) || /-/.match(w).present?}
      w = handle_hyphens(w) if /-/.match(w).present?
      tagline << w
    end
    tagline.join(" ").gsub(/ ,/, ",")
  end

  def format_description(obj_values)
    #artists
    if obj_values["description_hash"]["artists"].present?
      obj_values["description_hash"]["medium_description"] = "#{obj_values["description_hash"]["medium_description"]} #{obj_values["description_hash"]["artists"]}"
    end
    #numbering/signature
    if obj_values["description_hash"]["numbering"].blank? && obj_values["description_hash"]["signature"].blank?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]}."
    elsif obj_values["description_hash"]["numbering"].present? && obj_values["description_hash"]["signature"].blank?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]} that is #{obj_values["description_hash"]["numbering"]}."
    elsif obj_values["description_hash"]["numbering"].blank? && obj_values["description_hash"]["signature"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]} that is #{obj_values["description_hash"]["signature"]}."
    elsif obj_values["description_hash"]["numbering"].present? && obj_values["description_hash"]["signature"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]}, #{obj_values["description_hash"]["numbering"]} and #{obj_values["description_hash"]["signature"]}."
    end
    #framing
    if obj_values["description_hash"]["framing"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["description"]} #{obj_values["description_hash"]["framing"]}"
    end
    #certificate
    if obj_values["description_hash"]["certificate"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["description"]} #{obj_values["description_hash"]["certificate"]} #{obj_values["description_hash"]["measurements"]}"
    else
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["description"]} #{obj_values["description_hash"]["measurements"]}"
    end
  end

  def format_tagline(obj_values)
    #framing
    if obj_values["tagline_hash"]["framing"].present?
      obj_values["tagline_hash"]["tagline"] = "Framed #{obj_values["tagline_hash"]["medium_tag"]}"
    else
      obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["medium_tag"]}"
    end

    #just punctuate
    if obj_values["tagline_hash"]["numbering"].blank? && obj_values["tagline_hash"]["signature"].blank? && obj_values["tagline_hash"]["certificate"].blank?
      obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["tagline"]}."
    else
      obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["tagline"]},"
    end

    #numbering and signature
    if obj_values["tagline_hash"]["numbering"].present? || obj_values["tagline_hash"]["signature"].present?
      values = [obj_values["tagline_hash"]["numbering"], obj_values["tagline_hash"]["signature"]]
      values = values.reverse if values[-1].nil?
      obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["tagline"]} #{values.join(" and ")}"
    end
    #certificate
    if obj_values["tagline_hash"]["certificate"].present?
      obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["tagline"]} #{obj_values["tagline_hash"]["certificate"]}."
    else
      obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["tagline"]}."
    end
    obj_values["tagline_hash"]["tagline"] = conditional_capitalize(obj_values["tagline_hash"]["tagline"])
    #artists
    obj_values["tagline_hash"]["tagline"] = "#{obj_values["tagline_hash"]["intro"]} #{obj_values["tagline_hash"]["tagline"]}"
  end

  #this works
  def build_medium(obj_values)
    [[ obj_values["item_type"].try(:[], "embellish_kind"), obj_values["item_type"].try(:[], "limited_kind"), obj_values["item_type"].try(:[], "medium"), obj_values["item_type"].try(:[], "sculpture_kind")].join(" ")]
  end

  def build_medium2(obj_values)
    medium2 = [ obj_values["item_type"].try(:[], "leafing_kind"), obj_values["item_type"].try(:[], "remarque_kind") ].reject {|kind| kind.nil?}
    if medium2.count > 0
      medium2.count == 1 ? ["with #{medium2.join(" ")}"] : ["with #{medium2.join(" and ")}"]
    else
      [""]
    end
  end

  #this works
  def build_substrate(obj_values)
    if obj_values["substrate_type"].present? && obj_values["substrate_type"]["#{obj_values["substrate_type"]["substrate_name"]}_kind"].present?
      substrate = obj_values["substrate_type"]["substrate_name"] + "_kind"
      substrate != "paper_kind" ? [ "on #{obj_values["substrate_type"][substrate]}",  "on #{obj_values["substrate_type"][substrate]}"] : ["","on #{obj_values["substrate_type"][substrate]}"  ]
    else
      [""]
    end
  end

  #dimensions dependency
  def build_sculpture_dim(dim_arr, dims, obj_values)
    dim_arr.each do |dim|
      dims << "#{obj_values["dimension_type"][dim]}\" (#{dim})"
    end
    "Measures approx. #{dims.join(" x ")}."
  end

  #dimensions-->add framing method
  def build_dims(obj_values)
    dimension_name = obj_values["dimension_type"]["dimension_name"] if obj_values["dimension_type"].try(:[], "dimension_name")
    if dimension_name.present?
      dims = []
      dim_arr = dimension_name.split(" & ")
      if dim_arr[-1] == "weight"
        [build_sculpture_dim(dim_arr, dims, obj_values)]
      elsif dim_arr[-1] != "weight"
        image_dim = "Measures approx. #{obj_values["dimension_type"]["width"]}\" x #{obj_values["dimension_type"]["height"]}\""
        if dim_arr.count == 1
          ["Measures approx. #{image_dim} (#{dim_arr[0]})"]
        elsif dim_arr.count == 2
          ["Measures approx. #{obj_values["dimension_type"]["outer_width"]}\" x #{obj_values["dimension_type"]["outer_height"]}\" (#{dim_arr[-1]}); #{image_dim} (#{dim_arr[0]})"]
        end
      end
    else
      [""]
    end
  end

  def build_framing(obj_values)
    if obj_values["dimension_type"].try(:[], "frame_kind").nil?
      [""]
    else
      ["Framed", "This piece is #{obj_values["dimension_type"]["frame_kind"]}."]
      #obj_values["dimension_type"].try(:[], "frame_kind").present? ? ["Framed", "This piece is #{obj_values["dimension_type"]["frame_kind"]}."] : [""]
    end
  end

  def build_edition(obj_values)
    if obj_values["edition_type"].present?
      if obj_values["edition_type"]["edition_name"] == "x/y"
        numbered = [ obj_values["edition_type"].try(:[], "edition_kind"), "numbered"].join(" ") #reject {|kind| kind.nil?}
        if obj_values["edition_type"]["number"].present? && obj_values["edition_type"]["edition_size"].present?
          numbering = ["#{numbered} #{obj_values["edition_type"]["number"]}/#{obj_values["edition_type"]["edition_size"]}"]
        elsif obj_values["edition_type"]["number"].blank? && obj_values["edition_type"]["edition_size"].present?
          numbering = ["#{numbered} out of #{obj_values["edition_type"]["edition_size"]}"]
        elsif obj_values["edition_type"]["number"].blank? && obj_values["edition_type"]["edition_size"].blank?
          numbering = [numbered]
        end
      else
        numbering = ["numbered from a #{obj_values["edition_type"]["edition_kind"]} edition"]
      end
    elsif obj_values["edition_type"].nil?
      [""]
    end
  end

  def build_signature(obj_values)
    if obj_values["signature_type"].present? && obj_values["signature_type"]["signature_kind"].present?
      signature_kind = obj_values["signature_type"]["signature_kind"]
      if signature_kind == "unsigned"
        [ "", "This piece is not signed." ]
      elsif signature_kind == "hand signed" || signature_kind == "hand signed and thumb printed"
        [ signature_kind, "#{signature_kind} by the artist" ]
      elsif signature_kind == ("plate signature" || "authorized signature")
        [ "signed", "bearing the #{signature_kind} of the artist" ]
      elsif signature_kind == "autographed"
        [ "#{signature_kind} by #{artists[-1]}", "#{signature_kind} by #{artists[-1]}" ]
      end
    else  obj_values["signature_type"].nil? || obj_values["signature_type"]["signature_kind"].nil?
      [""]
    end
  end

  def build_certificate(obj_values)
    if obj_values["certificate_type"].present? && (obj_values["certificate_type"]["certificate_kind"].present? || obj_values["certificate_type"]["issuer"].present?)
      certificate = obj_values["certificate_type"]["certificate_name"] == "general certificate" ? [ "general certificate", obj_values["certificate_type"]["certificate_kind"] ]  : [ "issuer", obj_values["certificate_type"]["issuer"] ]
      if certificate[0] == "general certificate"
        ["with #{certificate[1]}", "Includes #{conditional_capitalize(certificate[1])}."]
      else
        ["with Certificate of Authenticity from #{certificate[1]}", "Includes Certificate of Authenticity from #{certificate[1]}"]
      end
    elsif obj_values["certificate_type"].nil? || (obj_values["certificate_type"]["certificate_kind"].nil? && obj_values["certificate_type"]["issuer"].nil?)
      [""]
    end
  end

  def medium_ed_sign_cert(medium, obj_values)
    certificate = obj_values["build"]["certificate"][0] if obj_values["build"]["certificate"][0].present?
    edition_signature_arr = [obj_values["build"]["edition"][0], obj_values["build"]["signature"][0]] if obj_values["build"]["edition"][0].present? || obj_values["build"]["signature"][0].present? #.reject {|kind| kind.blank?}
    if edition_signature_arr.blank?
      medium = certificate.present? ? "#{medium}, #{certificate}" : "#{medium}"
    else
      #"medium, <x> and <y>"
      if edition_signature_arr.count == 2
        edition_signature_arr = edition_signature_arr.join(" and ")
      elsif edition_signature_arr.count == 1 && certificate.blank?
        edition_signature_arr = edition_signature_arr[-1].blank? ? edition_signature_arr.reverse.join(" and ") : edition_signature_arr.join(" and ")
      elsif edition_signature_arr.count == 1 && certificate.present?
        edition_signature_arr = edition_signature_arr.join("")
      end
      medium = "#{medium}, #{edition_signature_arr} #{certificate}"
    end
  end

  def medium_ed_sign(medium, obj_values)
    edition_signature_arr = [obj_values["build"]["edition"][0], obj_values["build"]["signature"][-1]] if obj_values["build"]["edition"][0].present? || obj_values["build"]["signature"][-1].present?
    "#{medium}" if edition_signature_arr.reject {|v| v.blank?}.blank?
    if edition_signature_arr.reject {|v| v.blank?}.count == 2
      "#{medium}, #{edition_signature_arr.join(" and ")}"
    elsif edition_signature_arr.reject {|v| v.blank?}.count == 1
      edition_signature_arr[-1].present? ? "#{medium}, #{edition_signature_arr[-1]}." : "#{medium}, and #{edition_signature_arr[0]}"
    end
  end

  def build(obj_values)
    medium = [obj_values["build"]["framing"][0], obj_values["build"]["medium"][0], obj_values["build"]["substrate"][0], obj_values["build"]["medium2"][0]].join(" ")
    "#{tagline_intro} #{conditional_capitalize(medium_ed_sign_cert(medium, obj_values))}."
  end

  def build_description(obj_values)
    medium = [obj_values["build"]["medium"][0], obj_values["build"]["substrate"][-1], "#{artists[-1]}", obj_values["build"]["medium2"][-1]].join(" ")
    [description_intro(medium.strip), "#{medium_ed_sign(medium, obj_values)}.", obj_values["build"]["framing"][-1], obj_values["build"]["certificate"][-1], obj_values["build"]["dimensions"][-1]].join(" ") #, obj_values["build"]["certificate"][-1], obj_values["build"]["dimensions"][-1], obj_values["build"]["framing"][0],
  end

  #PRIMARY METHOD
  def hashed_item_values
    #1 retrieve <type> objects
    assoc_hash = {
      #k => v, if v.present?
      "item_type" => self.try(:item_type),
      "edition_type" => self.try(:edition_type),
      "dimension_type" => self.try(:dimension_type),
      "substrate_type" => self.try(:substrate_type),
      "signature_type" => self.try(:signature_type),
      "certificate_type" => self.try(:certificate_type)
    }

    #3 k: "item_type", v: ItemType.find(n) #=> remove k/v pairs with nil values
    assoc_hash = assoc_hash.keep_if { |k,v| v.present? }
    #assoc_keys = assoc_hash2.keys

    if assoc_hash.present? && self.properties.present?

      #top key set before assoc_hash loop
      obj_values = Hash.new
      obj_values["description_hash"] = {"medium_description" => nil}
      obj_values["tagline_hash"] = {"medium_description" => nil}
      #obj_values["test_hash"] = {"test" => nil}
      #assoc_hash2 loop
      assoc_hash.each do |k, v|
        #e.g. item_type -> item_hash #=> this value is set for each k/v, string at this point
        obj_values[k] = {k.gsub(/type/, "name") => v.name}
        #obj_values[k] = {k.gsub(/_type/, "") => "name"}

        if v.fields.present?
          #e.g., item_type.fields.each
          v.fields.each do |f|
            obj_values[k]["medium"] = self.properties[f.name] if ["media"].any? { |word| f.name.include?(word) }
            obj_values[k][f.name] = self.properties[f.name]
          end
        end
        #^end: v.present condition
      end
      #^end: assoc_hash2.present?
      format_values(obj_values)
      format_tagline(obj_values)
      format_description(obj_values)
      build_medium(obj_values)
      obj_values["build"] = {
        "framing" => build_framing(obj_values),
        "medium" => build_medium(obj_values),
        "substrate" => build_substrate(obj_values),
        "medium2" => build_medium2(obj_values),
        "edition" => build_edition(obj_values),
        "signature" => build_signature(obj_values),
        "certificate" => build_certificate(obj_values),
        "dimensions" => build_dims(obj_values)
      }
    end
    [ build(obj_values), build_description(obj_values) ] #obj_values["build"], build_description(obj_values),
  end
end
