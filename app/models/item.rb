class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type
  belongs_to :invoice

  has_many :artist_items, dependent: :destroy
  has_many :artists, through: :artist_items, dependent: :destroy
  delegate :first_name, :last_name, :to => :artist

  validates :sku, :numericality => { :only_integer => true }
  validates :image_width, :numericality => { :only_integer => true }
  validates :image_height, :numericality => { :only_integer => true }


  # validate :validate_item_properties
  # validate :validate_mounting_properties

  def validate_item_properties
    item_type.fields.each do |field|
      if field.required? && properties[field.name].blank?
        errors.add field.name, "must not be blank"
      end
    end
  end

  def validate_mounting_properties
    mounting_type.fields.each do |field|
      if field.required? && properties[field.name].blank?
        errors.add field.name, "must not be blank"
      elsif (field.name == 'frame_width' || field.name == 'frame_width') && properties[field.name].class != Fixnum
        errors.add field.name, "must be a number"
      end
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

  def artists_names
    artists = self.artist_ids.map { |artist| Artist.find(artist) }
    if artists.count == 1
      artists_names = "#{artists.first.full_name}"
    elsif artists.count > 1
      artists_names = "{artists.first.full_name} & {artists.last.full_name}"
    end
  end

  def item_title
    if self.title.blank?
      "Untitled"
    else
      capitalize_words(self.title)
    end
  end

  def item_retail
    self.retail
  end

  def item_item_type
    self.item_type.name
  end

  def art_type
    if item_item_type == "Original Painting"
      item_item_type.split(" ").first
    elsif item_item_type == "Original Sketch"
      item_item_type.split(" ").first
    elsif item_item_type == "One-of-a-Kind"
      item_item_type.split(" ").first
    elsif item_item_type == "Limited Edition"
      self.properties["limited_type"] unless self.properties.nil? || self.properties["limited_type"].nil?
    end
  end

  def media_type
    if self.properties != nil
      if item_item_type == "Original Painting"
        self.properties["paint_type"]
      elsif item_item_type == "One-of-a-Kind"
        self.properties["mixed_media_type"] unless self.properties["mixed_media_type"].nil?
      elsif item_item_type == "Original Sketch"
        "#{self.properties["sketch_type"]} #{self.properties["sketch_media_type"]}"
      elsif item_item_type == "Limited Edition"
        self.properties["ink_type"] unless self.properties["ink_type"].nil?
      end
    end
  end

  def embellish_type
    if self.properties != nil
      "Hand Embellished" if self.properties["hand_embellished"] == "1"
    end
  end

  def leafing_type
    if self.properties != nil
      if self.properties["gold_leaf"] == "1"
        "with Gold Leaf"
      elsif self.properties["silver_leaf"] == "1"
        "with Silver Leaf"
      end
    end
  end

  def item_substrate_type
    if self.properties.nil? && self.properties["#{self.substrate_type}"] != nil
      self.properties["#{self.substrate_type.name.downcase}_type"]
    end
  end

  def item_mounting_type
    if self.properties != nil && item_substrate_type != nil
      if item_substrate_type.split(" ").first != "Gallery" && item_substrate_type.split(" ").first != "Stretched"
        if self.mounting_type.name == "Framed"
          self.mounting_type.name #unless
        elsif self.mounting_type.name == "Unframed without border"
          "Unframed (no border)"
        elsif "unframed with border"
          "Unframed (with border)"
        end
      end
    end
  end

  def item_image_dim
    "#{self.image_width}\" x #{self.image_height}\"" unless self.image_width.nil? || self.image_height.nil?
  end

  def item_framed_dim
    if self.properties != nil
      "#{self.properties["frame_width"]}\" x #{self.properties["frame_height"]}\"" unless self.properties["frame_width"].nil? || self.properties["frame_height"].nil?
    end
  end

  def item_unframed_border_dim
    if self.properties != nil
      "#{self.properties["border_width"]}\" x #{self.properties["border_height"]}\"" if item_mounting_type == "Unframed (with border)"
    end
  end

  def item_dimensions
    if self.mounting_type_id != nil
      if self.mounting_type.name == "Framed"
        "Measures approx. #{self.item_framed_dim} (framed); #{self.item_image_dim} (image)"
      elsif item_mounting_type == "Unframed (with border)"
        "Measures approx. #{self.item_unframed_border_dim} (border); #{self.item_image_dim} (image)"
      elsif item_mounting_type == "Unframed (no border)"
        "Measures approx. #{self.item_image_dim} (image)"
      end
    end
  end

  def item_signature_type
    if self.properties != nil && self.signature_type != nil
      "Hand Signed" if self.signature_type.name == "Signature"
    end
  end

  def item_certificate_type
    if self.properties?
      if self.certificate_type != nil && self.certificate_type.name == "Authentication"
        "with #{self.properties["authentication_type"]}"
      end
    end
  end

  def item_remarque
    if self.properties? && item_item_type == "Limited Edition"
      "with Hand Drawn Remarque" if self.properties["remarque"] == "1"
    end
  end

  #numbering
  def item_numbering_type
    if self.properties? && item_item_type == "Limited Edition"
      self.properties["numbering_type"] unless self.properties["numbering_type"] == "standard"
    end
  end

  def item_numbering_or_qty
    if item_item_type == "Limited Edition"
      if self.properties["number"] != nil && self.properties["edition_size"] != nil
        "Numbered #{self.properties["number"]}/#{self.properties["edition_size"]}"
      elsif self.properties["number"].nil? && self.properties["edition_size"] != nil
        "Numbered out of #{self.properties["edition_size"]}"
      elsif self.properties["number"].nil? && self.properties["edition_size"].nil?
        "Numbered"
      end
    end
  end

  def item_numbering
    if item_item_type == "Limited Edition"
      "#{item_numbering_type} #{item_numbering_or_qty}"
    end
  end
end
