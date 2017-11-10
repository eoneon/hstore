class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :dimension_type
  belongs_to :edition_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type
  belongs_to :invoice

  has_many :artist_items, dependent: :destroy
  has_many :artists, through: :artist_items, dependent: :destroy
  delegate :first_name, :last_name, :to => :artist

  before_save :set_title
  before_save :set_image_size

  #need to assign attribute
  def set_image_size
    self.image_size = image_size
  end

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
      medium_description.first =~ /\A[^aeiou]/ ? "This is a " : "This is an"
    else
      medium_description.first =~ /\A[^aeiou]/ ? "#{item_title} is a " : "#{item_title} is an"
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
  def build_medium
    medium = []
    media = properties.map { |k,v| medium << v if ["media"].any? { |m| k.include?(m)}}
    [[ properties["embellish_kind"], properties["limited_kind"], media, properties["sculpture_kind"]].join(" ").strip]
  end

  def build_medium2
    medium2 = [ properties["leafing_kind"], properties["remarque_kind"] ].reject {|kind| kind.blank?}
    if medium2.count > 0
      medium2.count == 1 ? ["with #{medium2.join(" ")}"] : ["with #{medium2.join(" and ")}"]
    else
      [""]
    end
  end

  def medium_ed_sign_cert(medium)
    certificate = build_certificate[0] if build_certificate[0].present?
    edition_signature_arr = [build_edition[0], build_signature[0]]
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

  def medium_ed_sign(medium)
    edition_signature_arr = [build_edition[0], build_signature[-1]]
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
  def build_substrate
    substrate_kind = nil
    properties.keys.map {|k| substrate_kind = k if k == "canvas_kind" || k == "paper_kind" || k == "other_kind"}
    if substrate_kind.present?
      substrate_kind != "paper_kind" ? [ "on #{properties[substrate_kind]}",  "on #{properties[substrate_kind]}"] : ["","on #{properties[substrate_kind]}" ]
    else
      [""]
    end
  end

  #dimensions dependency
  def image_size
    if properties?
      properties["width"].to_f * properties["height"].to_f
    end
  end

  def dimension_name
    dimension_type.name if dimension_type.present?
  end

  def dim_arr
    dimension_name.split(" & ") if dimension_name.present?
  end

  def build_sculpture_dim(dim_arr, dims)
    dim_arr.each do |dim|
      dims << "#{properties[dim]}\" (#{dim})"
    end
    "Measures approx. #{dims.join(" x ")}."
  end

  def build_dims
    #if dim_name(dimension_type).present?
    if dimension_name.present?
      dims = []
      dim_arr = dimension_name.split(" & ")
      #dim_arr = dim_name(dimension_type).split(" & ")
      if dim_arr[-1] == "weight"
        [build_sculpture_dim(dim_arr, dims)]
      elsif dim_arr[-1] != "weight"
        image_dim = "Measures approx. #{properties["width"]}\" x #{properties["height"]}\""
        if dim_arr.count == 1
          ["Measures approx. #{image_dim} (#{dim_arr[0]})."]
        elsif dim_arr.count == 2
          ["Measures approx. #{properties["outer_width"]}\" x #{properties["outer_height"]}\" (#{dim_arr[-1]}); #{image_dim} (#{dim_arr[0]})."]
        end
      end
    else
      [""]
    end
  end

  def build_framing
    if dimension_type.present? && properties["frame_kind"].present?
      ["Framed", "This piece is #{properties["frame_kind"]}."]
    else
      [""]
    end
  end

  def build_edition
    if properties["limited_kind"].present? && edition_type.present?
      if edition_type.name == "x/y"
        numbered = [properties["edition_kind"], "numbered"].join(" ").strip
        if properties["number"].present? && properties["edition_size"].present?
          numbering = ["#{numbered} #{properties["number"]}/#{properties["edition_size"]}"]
        elsif properties["number"].blank? && properties["edition_size"].present?
          numbering = ["#{numbered} out of #{properties["edition_size"]}"]
        elsif properties["number"].blank? && properties["edition_size"].blank?
          numbering = [numbered]
        end
      else
        numbering = ["numbered from a #{properties["edition_kind"]} edition"]
      end
    else
      [""]
    end
  end

  def build_signature
    if properties["signature_kind"].present?
      signature_kind = properties["signature_kind"]
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

  def build_certificate
    if properties["certificate_kind"].present?
      ["with #{properties["certificate_kind"]}", "Includes #{conditional_capitalize(properties["certificate_kind"])}."]
    elsif properties["issuer"].present?
      ["with Certificate of Authenticity from #{properties["issuer"]}", "Includes Certificate of Authenticity from #{properties["issuer"]}."]
    else
      [""]
    end
  end

  def build_tagline
    if properties.present?
      medium = [ build_framing[0], build_medium[0], build_substrate[0], build_medium2[0] ].join(" ").strip
      period = "." if medium.length > 0
      "#{tagline_intro} #{conditional_capitalize(medium_ed_sign_cert(medium))}#{period}"
    end
  end

  def build_description
    if properties.present?
      medium = [build_medium[0], build_substrate[-1], "#{artists[-1]}", build_medium2[-1]].join(" ").strip
      [description_intro(medium), "#{medium_ed_sign(medium)}.", build_framing[-1], build_certificate[-1], build_dims[-1]].join(" ")
    end
  end

  #PRIMARY METHOD
  def hashed_item_values
    [ build_tagline, build_description ]
  end
end
