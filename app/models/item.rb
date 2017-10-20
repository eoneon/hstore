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

  before_save :set_art_type, :set_category

  def set_art_type
    if ["original", "one-of-a-kind"].any? { |word| self.item_type.name.include?(word) }
      self.art_type = "original"
    elsif ["sculpture", "glass"].any? { |word| self.item_type.name.include?(word) }
      self.art_type = "sculpture/glass"
    elsif ["limited", "print", "poster"].any? { |word| self.item_type.name.include?(word) }
      self.art_type = self.item_type.name
    end
  end

  def set_category
    if ["original", "one-of-a-kind"].any? { |word| self.item_type.name.include?(word) }
      self.category = "original painting"
    elsif ["limited", "print", "poster"].any? { |word| self.item_type.name.include?(word) }
      self.category = "limited edition"
    elsif ["glass"].any? { |word| self.item_type.name.include?(word) }
      self.category = "hand blown glass"
    elsif ["sculpture"].any? { |word| self.item_type.name.include?(word) }
      self.category = "sculpture"
    end
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
    self.title.blank? ? "Untitled" : capitalize_words(self.title)
  end

  def artists
    artists = self.artist_ids.map { |a| Artist.find(a).full_name }
    if artists.count == 1
      artists.first
    elsif artists.count > 1
      "#{artists.first} and #{artists.last}"
    end
  end

  def sculpture_description(v2, medium_tag, medium_description)
    medium_tag << v2
    medium_description << v2
  end

  def flat_tag(obj_values, k2, v2, substrate_kind, medium_tag)
    if ["paint_media", "mixed_media", "ink_media", "sketch_media", "print_media"].any? { |word| k2.include?(word) }
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
    if ["paint_media", "mixed_media", "ink_media", "sketch_media", "print_media"].any? { |word| k2.include?(word) }
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
          if obj_values["dimension_type"]["dimension_name"].split(" & ").last == "weight"
            sculpture_description(v2, medium_tag, medium_description)
          else
            substrate_kind = "#{obj_values["substrate_type"]["substrate_name"]}_kind"
            flat_tag(obj_values, k2, v2, substrate_kind, medium_tag)
            flat_description(obj_values, k2, v2, substrate_kind, medium_description)
          end

        end
        obj_values[k]["medium_tag"] = medium_tag.join(" ")
        obj_values[k]["medium_description"] = medium_description.join(" ")
            #pause at media value k2/v2
        #     if ["paint_media", "mixed_media", "ink_media", "sketch_media", "print_media"].any? { |word| k2.include?(word) }
        #
        #       substrate_kind = "#{obj_values["substrate_type"]["substrate_name"]}_kind"
        #       medium_description << "#{v2} on #{obj_values["substrate_type"][substrate_kind]}"
        #       next if v2 == "giclee" && substrate_kind == "paper_kind"
        #       if v2 == "giclee" && substrate_kind != "paper_kind"
        #         v2 = " on #{obj_values["substrate_type"][substrate_kind]}"
        #       elsif v2 != "giclee" && substrate_kind != "paper_kind"
        #         medium_description << "#{v2} on #{obj_values["substrate_type"][substrate_kind]}"
        #       end
        #     medium_description << "#{v2} on #{obj_values["substrate_type"][substrate_kind]}"
        #     medium_tag = "#{v2} on #{obj_values["substrate_type"][substrate_kind]}" unless substrate_kind == "paper_kind"
        #     next
        #   elsif k2 == "leafing_kind"
        #     v2 = "with #{v2}"
        #   elsif k2 == "remarque_kind"
        #     v2 = obj_values[k]["leafing_kind"].present? ? "and #{v2}" : "with #{v2}"
        #   end
        #   #no conditions: scuplture
        #   medium_tag << v2
        #   medium_description << v2
        # end
        # obj_values[k]["medium_tag"] = medium_tag.join(" ")
        # obj_values[k]["medium_description"] = medium_description.join(" ")
      elsif k == "dimension_type"
        name_to_a = obj_values[k]["dimension_name"].split(" & ")
        if name_to_a[-1] == "weight"
          measurements = []
          format_sculpture_dimensions(name_to_a, obj_values, measurements)
          measurements = "Measures approx. #{measurements.join(" x ")}."
        else
          image_dim = "#{obj_values[k]["width"]} x #{obj_values[k]["height"]}"
          if name_to_a[0] == name_to_a[-1] #image only
            measurements = "Measures approx. #{image_dim} (#{name_to_a[0]})."
          else
            measurements = "Measures approx. #{obj_values[k]["outer_width"]} x #{obj_values[k]["outer_height"]} (#{name_to_a[-1]}); #{image_dim} (#{name_to_a[0]})."
            if name_to_a[-1] == "frame"
              obj_values[k]["frame_description"] = "This piece is #{obj_values[k]["frame_kind"]}."
              obj_values["item_type"]["medium_tag"] = "framed #{obj_values["item_type"]["medium_tag"]}"
            end
          end
        end
        # name_to_a = obj_values[k]["dimension_name"].split(" & ")
        # if name_to_a[-1] != "weight"
        #
        #   #only need these if: w or h larger than 36"; just prepend to medium + conditional substrate
        #   image_dim = "#{obj_values[k]["width"]} x #{obj_values[k]["height"]}"
        #   #obj_values["dimension_type"]["image_dim"] = "(#{image_dim})"
        #
        #   if name_to_a[0] == name_to_a[-1]
        #     obj_values[k]["measurements"] = "Measures approx. #{image_dim} (#{name_to_a[0]})."
        #   elsif name_to_a[0] != name_to_a[-1]
        #     obj_values[k]["measurements"] = "Measures approx. #{obj_values[k]["outer_width"]} x #{obj_values[k]["outer_height"]} (#{name_to_a[-1]}); #{image_dim} (#{name_to_a[0]})."
        #     obj_values[k]["frame_description"] = "This piece is #{obj_values[k]["frame_kind"]}." if name_to_a[-1] == "frame"
        #   end
        # else
        #   measurements = []
        #   name_to_a.each do |dim|
        #     measurements << "#{obj_values[k][dim]} (#{dim})"
        #   end
        #   obj_values[k]["measurements"] = measurements #"Measures approx. #{measurements.join(" x ")}."
        # end
        obj_values[k]["measurements"] = measurements
      elsif k == "edition_type"
        if obj_values[k]["edition_name"] == "x/y"
          numbered = obj_values[k]["edition_kind"].present? ? "#{obj_values[k]["edition_kind"]} numbered" : "numbered"
          if obj_values[k]["number"].present? && obj_values[k]["edition_size"].present?
            numbering = "#{numbered} #{obj_values[k]["number"]}/#{obj_values[k]["edition_size"]}"
          elsif obj_values[k]["number"].blank? && obj_values[k]["edition_size"].present?
            numbering = "#{numbered} out of #{obj_values[k]["edition_size"]}"
          end
        else
          numbering = "numbered from a #{obj_values[k]["edition_kind"]} edition"
        end
        obj_values["item_type"]["medium_tag"] = "#{obj_values["item_type"]["medium_tag"]}, #{numbering}"
        obj_values["item_type"]["medium_description"] = "#{obj_values["item_type"]["medium_description"]}, #{numbering}"
      elsif k == "signature_type"
        if obj_values[k]["signature_kind"] == "hand signed" || obj_values[k]["signature_kind"] == "hand signed and thumb printed"
          signature_tag = "#{obj_values[k]["signature_kind"]}"
          signature_description = "#{signature_tag} by the artist."
        elsif obj_values[k]["signature_kind"] == "plate signature" || obj_values[k]["signature_kind"] == "authorized signature"
          signature_tag = "signed" #"and " given some conditions
          signature_description = "bearing the #{obj_values[k]["signature_kind"]} of the artist."
        elsif obj_values[k]["signature_kind"] == "autographed"
          signature_tag = "#{obj_values[k]["signature_kind"]} by #{artists}."
          signature_description = signature_tag
        elsif obj_values[k]["signature_kind"] == "unsigned"
          signature_description = "This piece is not signed."
        end
        obj_values[k]["signature_tag"] = signature_tag
        obj_values[k]["signature_description"] = signature_description
      elsif k == "certificate_type"
        certificate_tag = "with #{obj_values[k]["certificate_kind"]}."
        certificate_description = "Includes #{obj_values[k]["certificate_kind"]}."
        obj_values[k]["certificate_tag"] = certificate_tag
        obj_values[k]["certificate_description"] = certificate_description
      end
      #^end of k == _type conditions
    end
  end


      #update [k][v] to [k2][v2] -> for attributes hash
      # obj_values["item_hash"]["item_type_name"] = "original"
      # obj_values["item_hash"]["art_type"] = obj_values["item_hash"]["item_type_name"]
      # obj_values["item_hash"].delete("item_type_name")

      #just required values
      #obj_values["media_hash"] = "#{v.name.split.first} #{field_values.join(" ")}"
    #elsif ["limited"].any? { |word| v.name.include?(word) }
      #duplication...
      # obj_values["item_hash"]["item_type_name"] #= "limited edition"
      # obj_values["item_hash"]["art_type"] = obj_values["item_hash"]["item_type_name"]
      # obj_values["item_hash"].delete("item_type_name")

      #obj_values["media_hash"] = field_values.join(" ")
    #else
    #  obj_values[k.gsub(/type/, "field_values")] = field_values
    #end


  def hashed_item_values
    # item_fields = {
    #   "sku" => self.sku,
    #   "title" => self.item_title,
    #   "artist" => self.artists,
    #   "retail" => self.retail,
    #   "image_width" => self.image_width,
    #   "image_height" => self.image_height,
    #   "art_type" => self.art_type,
    # }

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

    if assoc_hash2.present? && self.properties.present?

      #top key set before assoc_hash2 loop
      obj_values = Hash.new
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
    end

    # {"item_values" => {"obj_hash" => obj_hash, "assoc_hash" => assoc_hash, "prop_hash" => prop_hash, "attr_hash" => attr_hash, "medium_hash" => medium_hash}}
    {"obj_values" => obj_values }
  end
end
