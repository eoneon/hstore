class Category < ActiveRecord::Base
  before_create :set_sort
  before_destroy :update_sort

  private
  def set_sort
    self.sort = Category.count == 0 ? 1 : Category.maximum('sort') + 1
  end

  def update_sort
    sort_objs = Category.where("sort > ?", self.sort)
    sort_objs.each do |obj|
      obj.sort = obj.sort - 1
      obj.save!
    end
  end

  #own controller? start with category controller then move
  # def sort_up
  #   prev = Category.where("sort = ?", self.sort - 1)
  #
  # end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |category|
        csv << category.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    #create unless already exists
    category = find_by_id(row["id"]) || new
    #don't update id fields
    category.attributes = row.to_hash
    category.save!
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
end
