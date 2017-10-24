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
    capitalize_words(self.title) if self.title != "Untitled" && self.title.present?
  end

  def description_intro(medium_description)
    if self.title == "Untitled"
      medium_description.first =~ /\A[^aeiou]/ ? "This is a " : "This is an "
    else
      medium_description.first =~ /\A[^aeiou]/ ? "\"#{item_title}\" is a " : "\"#{item_title}\" is an "
    end
  end

  def artists
    artists = self.artist_ids.map { |a| Artist.find(a).full_name }
    artists.join(" and ")
  end

  def sculpture_description(v2, medium_tag, medium_description)
    medium_tag << v2
    medium_description << v2
  end

  def flat_tag(obj_values, k2, v2, substrate_kind, medium_tag)
    if ["media"].any? { |word| k2.include?(word) }
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
      v2 = "#{v2} on #{obj_values["substrate_type"][substrate_kind]}"
    elsif k2 == "leafing_kind"
      v2 = "with #{v2}"
    elsif k2 == "remarque_kind"
      v2 = obj_values["item_type"]["leafing_kind"].present? ? "and #{v2}" : "with #{v2}"
    end
    medium_description << v2
  end

  def format_sculpture_dimensions(name_to_a, obj_values, measurements)
    name_to_a.each do |dim|
      measurements << "#{obj_values["dimension_type"][dim]} (#{dim})"
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
          #assoc_keys.any? { |word| }
          if obj_values["dimension_type"].present? && obj_values["dimension_type"]["dimension_name"].split(" & ").last == "weight"
            sculpture_description(v2, medium_tag, medium_description)
          elsif obj_values["substrate_type"].present?
            #^could this be used universally to distinguish betsween scuputure/flat art?
            substrate_kind = "#{obj_values["substrate_type"]["substrate_name"]}_kind"
            #difference between tag/description: giclee, paper, punctuation.
            flat_tag(obj_values, k2, v2, substrate_kind, medium_tag) if substrate_kind.present?
            flat_description(obj_values, k2, v2, substrate_kind, medium_description) if substrate_kind.present?
            #medium_description = medium_description.join(" ")
          end
        end

        #punctuation = punctuation(obj_values)

        obj_values[k]["medium_tag"] = "#{medium_tag.join(" ")},"
        obj_values["description_hash"]["medium_description"] = "#{description_intro(medium_description)} #{medium_description.join(" ")}" #{description_intro(medium_description)}
        #obj_values[k]["medium_description"] = "#{description_intro(medium_description)} #{medium_description.join(" ")}#{punctuation}"

      elsif k == "dimension_type"
        name_to_a = obj_values[k]["dimension_name"].split(" & ")
        if name_to_a[-1] == "weight"
          measurements = []
          format_sculpture_dimensions(name_to_a, obj_values, measurements)
          measurements = "Measures approx. #{measurements.join(" x ")}."
        else
          image_dim = "#{obj_values[k]["width"]}\" x #{obj_values[k]["height"]}\""
          if name_to_a[0] == name_to_a[-1] #image only
            measurements = "Measures approx. #{image_dim} (#{name_to_a[0]})."
          else
            measurements = "Measures approx. #{obj_values[k]["outer_width"]}\" x #{obj_values[k]["outer_height"]}\" (#{name_to_a[-1]}); #{image_dim} (#{name_to_a[0]})."
            #
            if name_to_a[-1] == "frame"
              #obj_values["description_hash"]["frame_description"] = "This piece is #{obj_values[k]["frame_kind"]}."
              obj_values["description_hash"]["framing"] = "This piece is #{obj_values[k]["frame_kind"]}."
              obj_values["item_type"]["medium_tag"] = "framed #{obj_values["item_type"]["medium_tag"]}"
            end
          end
        end
        #make separate method for this
        #obj_values[k]["measurements"] = measurements
        obj_values["description_hash"]["measurements"] = measurements


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
        obj_values["item_type"]["medium_tag"] = "#{obj_values["item_type"]["medium_tag"]} #{numbering}"
        #obj_values["item_type"]["medium_description"] = "#{obj_values["item_type"]["medium_description"]} #{numbering}"
        obj_values["description_hash"]["numbering"] = numbering

      elsif k == "signature_type" && obj_values[k]["signature_kind"].present?
        if obj_values[k]["signature_kind"] == "unsigned"
          #obj_values["item_type"]["medium_description"] = "#{obj_values["item_type"]["medium_description"]}. This piece is not signed."
          obj_values["description_hash"]["signature"] = "This piece is not signed."
        elsif obj_values[k]["signature_kind"] != "unsigned"
          if obj_values[k]["signature_kind"] == "hand signed" || obj_values[k]["signature_kind"] == "hand signed and thumb printed"
            signature_tag = "#{obj_values[k]["signature_kind"]}"
            signature_description = "#{signature_tag} by the artist."
          elsif obj_values[k]["signature_kind"] == "plate signature" || obj_values[k]["signature_kind"] == "authorized signature"
            signature_tag = "signed"
            signature_description = "bearing the #{obj_values[k]["signature_kind"]} of the artist."
          elsif obj_values[k]["signature_kind"] == "autographed"
            signature_tag = "#{obj_values[k]["signature_kind"]} by #{artists}."
            signature_description = signature_tag
          end
          #obj_values["item_type"]["medium_tag"] =  "#{obj_values["item_type"]["medium_tag"]} and" if obj_values["edition_type"].present?

          obj_values["item_type"]["medium_tag"] = "#{obj_values["item_type"]["medium_tag"]} #{signature_tag}"
          #obj_values["item_type"]["medium_description"] = "#{obj_values["item_type"]["medium_description"]} #{signature_description}"
          #obj_values["item_type"]["medium_description"] = "#{obj_values["item_type"]["medium_description"]} #{obj_values["dimension_type"]["frame_description"]}" if obj_values["dimension_type"]["frame_description"].present?
          obj_values["description_hash"]["signature"] = signature_description
        end

      elsif k == "certificate_type" && (obj_values[k]["certificate_kind"].present? || obj_values[k]["issuer"].present?)
        if obj_values[k]["certificate_name"] == "general certificate"
          obj_values["item_type"]["medium_tag"] = "#{obj_values["item_type"]["medium_tag"]} with #{obj_values[k]["certificate_kind"]}."
          #obj_values[k]["certificate_description"] = "Includes #{capitalize_words(obj_values[k]["certificate_kind"])}."
          obj_values["description_hash"]["certificate"] = "Includes #{capitalize_words(obj_values[k]["certificate_kind"])}."
          #obj_values["item_type"]["medium_description"] = "#{obj_values["item_type"]["medium_description"]} #{obj_values[k]["certificate_description"]}"
        elsif obj_values[k]["certificate_name"] == "issued certificate"
          obj_values["item_type"]["medium_tag"] = "#{obj_values["item_type"]["medium_tag"]} with Certificate of Authenticity from #{obj_values[k]["issuer"]}."
          #obj_values[k]["certificate_description"] = "Includes Certificate of Authenticity from #{obj_values[k]["issuer"]}."
          obj_values["description_hash"]["certificate"] = "Includes Certificate of Authenticity from #{obj_values[k]["issuer"]}."
        end
      end
      #^end of k == _type conditions
    end
  end

  def punctuation(obj_values)
    if (obj_values["edition_type"].present? && obj_values["edition_kind"].present?) || (obj_values["signature_type"].present? && obj_values["signature_kind"].present?)
      ","
    else
      "."
    end
  end

  def format_tagline(obj_values)
    tagline = ["#{artists} -", "\"#{item_title}\""]
    obj_values["item_type"]["medium_tag"].split.each do |w|
      w = w.downcase.capitalize! unless ["of", "and", "or", "on", "with", "from"].any? { |word| w == word } #w.include?(word)
      if w == "One-of-a-kind"
        w = "One-of-a-Kind"
      end
      tagline << w
    end
    tagline.join(" ")
  end

  def format_description(obj_values)
    if obj_values["description_hash"]["numbering"].blank? && obj_values["description_hash"]["signature"].blank?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]}."
    elsif obj_values["description_hash"]["numbering"].present? && obj_values["description_hash"]["signature"].blank?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]} that is #{obj_values["description_hash"]["numbering"]}."
    elsif obj_values["description_hash"]["numbering"].blank? && obj_values["description_hash"]["signature"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]} that is #{obj_values["description_hash"]["signature"]}"
    elsif obj_values["description_hash"]["numbering"].present? && obj_values["description_hash"]["signature"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["medium_description"]}, #{obj_values["description_hash"]["numbering"]} and #{obj_values["description_hash"]["signature"]}"
    end
    if obj_values["description_hash"]["framing"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["description"]} #{obj_values["description_hash"]["framing"]}"
    end
    if obj_values["description_hash"]["certificate"].present?
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["description"]} #{obj_values["description_hash"]["certificate"]} #{obj_values["description_hash"]["measurements"]}"
    else
      obj_values["description_hash"]["description"] = "#{obj_values["description_hash"]["description"]} #{obj_values["description_hash"]["measurements"]}"
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
    assoc_hash2 = assoc_hash.keep_if { |k ,v| v.present? }
    assoc_keys = assoc_hash2.keys

    if assoc_hash2.present? && self.properties.present?

      #top key set before assoc_hash2 loop
      obj_values = Hash.new
      obj_values["description_hash"] = {"medium_description" => nil}
      #assoc_hash2 loop
      assoc_hash2.each do |k, v|
        #e.g. item_type -> item_hash #=> this value is set for each k/v, string at this point
        obj_values[k] = {k.gsub(/type/, "name") => v.name}
        #obj_values[k] = {k.gsub(/_type/, "") => "name"}

        if v.fields.present?
          #e.g., item_type.fields.each
          v.fields.each do |f|
            obj_values[k][f.name] = self.properties[f.name]
          end
        end
        #^end: v.present condition
      end
      #^end: assoc_hash2.present?
      format_values(obj_values)
      #format_tagline(obj_values)
      format_description(obj_values)
      #obj_values["item_type"]["medium_description"] = format_description(obj_values)
      obj_values["item_type"]["medium_tag"] = format_tagline(obj_values)
      obj_values["item_type"]["medium_description"] = format_description(obj_values)
    end

    # {"item_values" => {"obj_hash" => obj_hash, "assoc_hash" => assoc_hash, "prop_hash" => prop_hash, "attr_hash" => attr_hash, "medium_hash" => medium_hash}}
    [obj_values["item_type"]["medium_tag"], obj_values["item_type"]["medium_tag"], obj_values["description_hash"]["description"]]


  end
end
