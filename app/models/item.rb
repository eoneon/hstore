class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :dimension_type
  belongs_to :embellish_type
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

  def format_values(obj_values)
    obj_values.each do |k, v|
      if k == "item_type"
        medium = []
        v.each do |k2, v2|
          next if k2 == "item_name"
          medium << v2
        end
        obj_values[k]["medium"] = medium.join(" ")
      elsif k == "dimension_type"
        name_to_a = obj_values["dimension_type"]["dimension_name"].split(" & ")
        if name_to_a[-1] != "weight"
          image_dim = "#{obj_values["dimension_type"]["width"]} x #{obj_values["dimension_type"]["height"]}"
          obj_values["dimension_type"]["image_dim"] = "(#{image_dim})"
          if name_to_a[0] == name_to_a[-1]
            obj_values["dimension_type"]["measurements"] = "Measures approx. #{image_dim} (#{name_to_a[0]})."
          elsif name_to_a[0] != name_to_a[-1]
            obj_values["dimension_type"]["measurements"] = "Measures approx. #{obj_values["dimension_type"]["outer_width"]} x #{obj_values["dimension_type"]["outer_height"]} (#{name_to_a[-1]}); #{image_dim} (#{name_to_a[0]})."
            obj_values["dimension_type"]["frame_description"] = "This piece is #{obj_values["dimension_type"]["frame_kind"]}." if name_to_a[-1] == "frame"
          end
        else
          measurements = []
          name_to_a.each do |dim|
            measurements << "#{obj_values["dimension_type"][dim]} (#{dim})"
          end
          obj_values["dimension_type"]["measurements"] = "Measures approx. #{measurements.join(" x ")}."
        end

      #   if obj_values["dimension_type"]["dimension_name"] == "image & frame"
      #     inner = []
      #     outer = []
      #     v.each do |k2, v2|
      #       next if k2 == "dimension_name" || k2 == "frame_kind"
      #       if k2 == "width" || k2 == "height"
      #         inner << v2
      #       else
      #         outer << v2
      #       end
      #     end
      #   end
      #   obj_values[k]["inner"] = inner.join(" x ")
      #   inner = inner.join(" x ")
      #   outer = outer.join(" x ")
      #   obj_values[k]["measurements"] = "Measures approx. #{outer} (frame); #{inner} (image)."
      #   obj_values[k]["image_dim"] = "(#{inner})"
      #obj_values[k]["outer_dim"] = outer_dim
      end
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
          #medium = []
          v.fields.each do |f|
            obj_values[k][f.name] = self.properties[f.name]
            # if k == "item_type"
            #   medium << self.properties[f.name]
            # elsif k == "dimension_type"
            #   obj_values[k][f.name] = self.properties[f.name]
            # else
            #   obj_values[k][f.name] = self.properties[f.name]
            # end
          end
          #^end: v.fields loop
          #format_values(obj_values)
          #obj_values[k]["medium"] = medium.join(" ")
        end
        #^end: v.present condition
      end
      #^end: assoc_hash2.present?
      format_values(obj_values)
    end

    # prop_hash = Hash.new
    # if self.properties.present?
    #   self.properties.each do |k, v|
    #     prop_hash[k] = v unless v.blank? || v == "0" #update embellish_type/leafing_type and remove second condition to account for border_width and border_height
    #   end
    # end

    #attributes hash
    # attr_hash = Hash.new
    # if self.item_type.present?
    #   art_type = ["Original", "One-of-a-Kind"].any? { |word| assoc_hash["item_type"].include?(word) } ? "original" : assoc_hash["item_type"].downcase
    #   attr_hash = { "art_type" =>  art_type }
    # end

    # {"item_values" => {"obj_hash" => obj_hash, "assoc_hash" => assoc_hash, "prop_hash" => prop_hash, "attr_hash" => attr_hash, "medium_hash" => medium_hash}}
    {"obj_values" => obj_values }
  end

  #kill
  # def artists_names
  #   artists = self.artist_ids.map { |artist| Artist.find(artist) }
  #   if artists.count == 1
  #     artists_names = "#{artists.first.full_name}"
  #   elsif artists.count > 1
  #     artists_names = "{artists.first.full_name} & {artists.last.full_name}"
  #   end
  # end

  # def art_type
  #   if item_item_type == "Original Painting"
  #     item_item_type.split(" ").first
  #   elsif item_item_type == "Original Sketch"
  #     item_item_type.split(" ").first
  #   elsif item_item_type == "One-of-a-Kind"
  #     item_item_type.split(" ").first
  #   elsif item_item_type == "Limited Edition"
  #     self.properties["limited_type"] unless self.properties.nil? || self.properties["limited_type"].nil?
  #   end
  # end

  # def media_type
  #   if self.properties != nil
  #     if item_item_type == "Original Painting"
  #       self.properties["paint_type"]
  #     elsif item_item_type == "One-of-a-Kind"
  #       self.properties["mixed_media_type"] unless self.properties["mixed_media_type"].nil?
  #     elsif item_item_type == "Original Sketch"
  #       "#{self.properties["sketch_type"]} #{self.properties["sketch_media_type"]}"
  #     elsif item_item_type == "Limited Edition"
  #       self.properties["ink_type"] unless self.properties["ink_type"].nil?
  #     end
  #   end
  # end

  # def embellish_type
  #   if self.properties != nil
  #     "Hand Embellished" if self.properties["hand_embellished"] == "1"
  #   end
  # end

  # def leafing_type
  #   if self.properties != nil
  #     if self.properties["gold_leaf"] == "1"
  #       "with Gold Leaf"
  #     elsif self.properties["silver_leaf"] == "1"
  #       "with Silver Leaf"
  #     end
  #   end
  # end

  # def item_substrate_type
  #   if self.properties != nil && self.properties["#{substrate_type}"] != nil
  #     self.properties["#{substrate_type.name.downcase}_type"]
  #   end
  # end

  # def item_mounting_type
  #   if self.properties != nil && item_substrate_type != nil
  #     if item_substrate_type.split(" ").first != "Gallery" && item_substrate_type.split(" ").first != "Stretched"
  #       if self.mounting_type.name == "Framed"
  #         self.mounting_type.name #unless
  #       elsif self.mounting_type.name == "Unframed without border"
  #         "Unframed (no border)"
  #       elsif "unframed with border"
  #         "Unframed (with border)"
  #       end
  #     end
  #   end
  # end

  # def item_image_dim
  #   "#{self.image_width}\" x #{self.image_height}\"" unless self.image_width.nil? || self.image_height.nil?
  # end
  #
  # def item_framed_dim
  #   if self.properties != nil
  #     "#{self.properties["frame_width"]}\" x #{self.properties["frame_height"]}\"" unless self.properties["frame_width"].nil? || self.properties["frame_height"].nil?
  #   end
  # end
  #
  # def item_unframed_border_dim
  #   if self.properties != nil
  #     "#{self.properties["border_width"]}\" x #{self.properties["border_height"]}\"" if item_mounting_type == "Unframed (with border)"
  #   end
  # end
  #
  # def item_dimensions
  #   if self.mounting_type_id != nil
  #     if self.mounting_type.name == "Framed"
  #       "Measures approx. #{self.item_framed_dim} (framed); #{self.item_image_dim} (image)"
  #     elsif item_mounting_type == "Unframed (with border)"
  #       "Measures approx. #{self.item_unframed_border_dim} (border); #{self.item_image_dim} (image)"
  #     elsif item_mounting_type == "Unframed (no border)"
  #       "Measures approx. #{self.item_image_dim} (image)"
  #     end
  #   end
  # end
  #
  # def item_signature_type
  #   if self.properties != nil && self.signature_type != nil
  #     "Hand Signed" if self.signature_type.name == "Signature"
  #   end
  # end
  #
  # def item_certificate_type
  #   if self.properties?
  #     if self.certificate_type != nil && self.certificate_type.name == "Authentication"
  #       "with #{self.properties["authentication_type"]}"
  #     end
  #   end
  # end
  #
  # def item_remarque
  #   if self.properties? && item_item_type == "Limited Edition"
  #     "with Hand Drawn Remarque" if self.properties["remarque"] == "1"
  #   end
  # end

  #numbering
  # def item_numbering_type
  #   if self.properties? && item_item_type == "Limited Edition"
  #     self.properties["numbering_type"] unless self.properties["numbering_type"] == "standard"
  #   end
  # end
  #
  # def item_numbering_or_qty
  #   if item_item_type == "Limited Edition"
  #     if self.properties["number"] != nil && self.properties["edition_size"] != nil
  #       "Numbered #{self.properties["number"]}/#{self.properties["edition_size"]}"
  #     elsif self.properties["number"].nil? && self.properties["edition_size"] != nil
  #       "Numbered out of #{self.properties["edition_size"]}"
  #     elsif self.properties["number"].nil? && self.properties["edition_size"].nil?
  #       "Numbered"
  #     end
  #   end
  # end
  #
  # def item_numbering
  #   if item_item_type == "Limited Edition"
  #     "#{item_numbering_type} #{item_numbering_or_qty}"
  #   end
  # end
end
