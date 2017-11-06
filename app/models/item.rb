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

  before_save :set_title

  # def set_floats
  #   self.properties["width"].to_f
  # end

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

  def item_title
    "\"#{conditional_capitalize(self.title)}\"" if self.title != "Untitled" && self.title.present?
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

  #medium
  def build_medium(obj_values)
    medium = []
    media = self.properties.map { |k,v| medium << v if ["media"].any? { |m| k.include?(m)}}
    [[ self.properties["embellish_kind"], self.properties["limited_kind"], media, self.properties["sculpture_kind"]].join(" ").strip]
  end

  def build_medium2(obj_values)
    medium2 = [ self.properties["leafing_kind"], self.properties["remarque_kind"] ].reject {|kind| kind.blank?}
    if medium2.count > 0
      medium2.count == 1 ? ["with #{medium2.join(" ")}"] : ["with #{medium2.join(" and ")}"]
    else
      [""]
    end
  end

  def medium_ed_sign_cert(medium, obj_values)
    certificate = build_certificate(obj_values)[0] if build_certificate(obj_values)[0].present?
    edition_signature_arr = [build_edition(obj_values)[0], build_signature(obj_values)[0]]
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

  def medium_ed_sign(medium, obj_values)
    edition_signature_arr = [build_edition(obj_values)[0], build_signature(obj_values)[-1]]
    arr_count = edition_signature_arr.reject {|v| v.blank?}.count
    if arr_count == 0
      "#{medium}"
    elsif arr_count == 2
      "#{medium}, #{edition_signature_arr.join(" and ")}"
    elsif arr_count == 1
      edition_signature_arr[-1].present? ? "#{medium}, #{edition_signature_arr[-1]}" : "#{medium}, and #{edition_signature_arr[0]}"
    end
  end

  #this works
  def build_substrate(obj_values)
    substrate_kind = nil
    self.properties.keys.map {|k| substrate_kind = k if k == "canvas_kind" || k == "paper_kind" || k == "other_kind"}
    if substrate_kind.present?
      substrate_kind != "paper_kind" ? [ "on #{self.properties[substrate_kind]}",  "on #{self.properties[substrate_kind]}"] : ["","on #{self.properties[substrate_kind]}" ]
    else
      [""]
    end
  end

  #dimensions dependency
  def image_size
    if self.properties?
      self.properties["width"].to_f * self.properties["height"].to_f
    end
  end

  def dimension_name
    self.dimension_type.name if self.dimension_type.present?
  end

  def build_sculpture_dim(dim_arr, dims, obj_values)
    dim_arr.each do |dim|
      dims << "#{self.properties[dim]}\" (#{dim})"
    end
    "Measures approx. #{dims.join(" x ")}."
  end

  def build_dims(obj_values)
    if dimension_name.present?
      dims = []
      dim_arr = dimension_name.split(" & ")
      if dim_arr[-1] == "weight"
        [build_sculpture_dim(dim_arr, dims, obj_values)]
      elsif dim_arr[-1] != "weight"
        image_dim = "Measures approx. #{self.properties["width"]}\" x #{self.properties["height"]}\""
        if dim_arr.count == 1
          ["Measures approx. #{image_dim} (#{dim_arr[0]})."]
        elsif dim_arr.count == 2
          ["Measures approx. #{self.properties["outer_width"]}\" x #{self.properties["outer_height"]}\" (#{dim_arr[-1]}); #{image_dim} (#{dim_arr[0]})."]
        end
      end
    else
      [""]
    end
  end

  def build_framing(obj_values)
    if self.dimension_type.present? && self.properties["frame_kind"].present?
      ["Framed", "This piece is #{self.properties["frame_kind"]}."]
    else
      [""]
    end
  end

  def build_edition(obj_values)
    if self.properties["limited_kind"].present? && self.edition_type.present?
      if self.edition_type.name == "x/y"
        numbered = [self.properties["edition_kind"], "numbered"].join(" ").strip
        if self.properties["number"].present? && self.properties["edition_size"].present?
          numbering = ["#{numbered} #{self.properties["number"]}/#{self.properties["edition_size"]}"]
        elsif self.properties["number"].blank? && self.properties["edition_size"].present?
          numbering = ["#{numbered} out of #{self.properties["edition_size"]}"]
        elsif self.properties["number"].blank? && self.properties["edition_size"].blank?
          numbering = [numbered]
        end
      else
        numbering = ["numbered from a #{self.properties["edition_kind"]} edition"]
      end
    else
      [""]
    end
  end

  def build_signature(obj_values)
    if self.properties["signature_kind"].present?
      signature_kind = self.properties["signature_kind"]
      if signature_kind == "unsigned"
        [ "", "This piece is not signed." ]
      elsif signature_kind == "hand signed" || signature_kind == "hand signed and thumb printed"
        [ signature_kind, "#{signature_kind} by the artist" ]
      elsif signature_kind == "plate signature" || signature_kind == "authorized signature"
        [ "signed", "bearing the #{signature_kind} of the artist" ]
      elsif signature_kind == "autographed"
        [ "#{signature_kind} by #{artists[-1]}", "#{signature_kind} by #{artists[-1]}" ]
      end
    else
      [""]
    end
  end

  def build_certificate(obj_values)
    if self.properties["certificate_kind"].present?
      ["with #{self.properties["certificate_kind"]}", "Includes #{conditional_capitalize(self.properties["certificate_kind"])}."]
    elsif self.properties["issuer"].present?
      ["with Certificate of Authenticity from #{self.properties["issuer"]}", "Includes Certificate of Authenticity from #{self.properties["issuer"]}."]
    else
      [""]
    end
  end

  def build_tagline(obj_values)
    if self.properties.present?
      medium = [ build_framing(obj_values)[0], build_medium(obj_values)[0], build_substrate(obj_values)[0], build_medium2(obj_values)[0] ].join(" ").strip
      "#{tagline_intro} #{conditional_capitalize(medium_ed_sign_cert(medium, obj_values))}."
    end
  end

  def build_description(obj_values)
    if self.properties.present?
      medium = [build_medium(obj_values)[0], build_substrate(obj_values)[-1], "#{artists[-1]}", build_medium2(obj_values)[-1]].join(" ").strip
      [description_intro(medium), "#{medium_ed_sign(medium, obj_values)}.", build_framing(obj_values)[-1], build_certificate(obj_values)[-1], build_dims(obj_values)[-1]].join(" ")
    end
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
    if assoc_hash.present? && self.properties.present?

      obj_values = Hash.new
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

      #build_medium(obj_values)
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
    [ build_description(obj_values) ]#build_tagline(obj_values), build_description(obj_values), , build_edition(obj_values)[0] build_tagline(obj_values), build_description(obj_values)
  end
end
