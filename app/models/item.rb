class Item < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mounting_type
  belongs_to :certificate_type
  belongs_to :signature_type
  belongs_to :substrate_type
  belongs_to :invoice

  has_many :artist_items, dependent: :destroy
  has_many :artists, through: :artist_items
  delegate :first_name, :last_name, :to => :artist

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
    str.split.map { |word| word.capitalize! }.join(" ")
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
    title = self.title.blank? ? "untitled" : "#{self.title}"
    capitalize_words(title)
    # "\"#{capitalize_words(title)}\"" #=> for reference when I need to make this more conditional based on description field
  end

  def item_retail
    self.retail
  end

  def item_image_dim
    "(#{self.image_width} x #{self.image_height})" unless self.image_width.nil? || self.image_height.nil?
  end

  def item_item_type
    self.item_type.name
  end

  def art_type
    if item_item_type == "original painting"
      item_item_type.split(" ").first
    elsif item_item_type == ("one-of-a-kind" || "original sketch")
      item_item_type
    elsif item_item_type == "limited edition"
      self.properties["limited_type"] unless self.properties.nil? || self.properties["limited_type"].nil?
    end
  end

  def media_type
    if self.properties.nil?
      if item_item_type == "original painting"
        self.properties["paint_type"]
      elsif item_item_type == "one-of-a-kind"
        self.properties["mixed_media_type"]
      elsif item_item_type == "original sketch"
        self.properties["sketch_media_type"]
      elsif item_item_type == "limited edition"
         
        media = self.properties["hand_embellished"] == "1" ? "hand embellished #{item.properties["ink_type"]}" : self.properties["ink_type"]
        media = self.properties["gold_leaf"] == "1" ? "#{media} with gold leaf" : media
        self.properties["silver_leaf"] == "1" ? "#{media} with silver leaf" : media
      end
    end
  end

  def item_substrate_type
    unless self.properties.nil? || self.properties["#{self.substrate_type}"].nil?
      " on " + self.properties["#{self.substrate_type.name}_type"]
    end
  end

  def item_mounting_type
    self.mounting_type.name unless item_substrate_type.split(" ").first != ("gallery" || "stretched") unless item_substrate_type.nil?
  end

  def item_framed_dim
    "(#{self.frame_width} x #{self.frame_height})" if item_mounting_type == "framed"
  end

  def item_unframed_border_dim
    "(#{self.border_width} x #{self.border_height})" if item_mounting_type == "unframed with border"
  end

  def item_signature_type
    "hand signed by the artist" if self.signature_type.name == "signature"
  end

  def item_certificate_type
    if self.properties?
      if self.certificate_type != nil && self.certificate_type.name == "authentication"
        "with #{self.properties["authentication_type"]}"
      end
    end
  end

  def item_remarque
    if self.properties?
      "with hand drawn remarque" if self.properties["remarque"] == "1"
    end
  end

  #numbering
  def item_numbering_type
    if self.properties? && self.properties["numbering_type"] != nil
      self.properties["numbering_type"]
    end
  end

  def item_numbering_or_qty
    if self.properties?
      if self.properties["number"] != nil && self.properties["edition_size"] != nil
        "numbered #{self.properties["number"]}/#{self.properties["edition_size"]}"
      elsif self.properties["number"].nil? && self.properties["edition_size"] != nil
        "numbered out of #{self.properties["edition_size"]}"
      elsif self.properties["number"].nil? && self.properties["edition_size"].nil?
        "numbered"
      end
    end
  end

  def item_numbering
    "#{item_numbering_type} #{item_numbering_or_qty}"
  end
end
