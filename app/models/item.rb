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

  attr_accessor :sku_range, :first_name, :last_name

  before_save :set_title, :set_image_size, :set_retail #, :create_artist
  #after_find :new_skus, if: :create_skus?

  #need to assign attribute
  def set_image_size
    self.image_size = image_size
  end

  def set_title
    self.title = "Untitled" if self.title.blank?
  end

  def set_retail
    self.retail = 0 if self.retail.blank?
  end

  # def create_artist
  #   Artist.create!(first_name: first_name, last_name: last_name) unless first_name.blank? && last_name.blank?
  #   new_artist = Artist.last
  #   self.artist_ids = new_artist.id
  # end

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

  def full_display_names
    artist_ids.map { |a| Artist.find(a).full_display_name }
  end

  #remove
  def artists_full_names
    artist_ids.map { |a| Artist.find(a).full_name }
  end

  def artists_last
    artist_ids.map { |a| Artist.find(a).last_name } #if a.full_name.join(" ").count >= 2
  end

  def artists_dob
    artist_ids.map { |a| Artist.find(a).dob } #=> [[2000, 2015], [2003, 2007]]
  end

  def reserved_list
    ValueItem.where(kind: "edition_kind").pluck(:name) + ["a", "of", "and", "or", "on", "with", "from", ","]
  end
end
