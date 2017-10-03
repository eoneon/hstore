class ValueItem < ActiveRecord::Base
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |item|
        csv << value_item.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    #create unless already exists
    value_item = find_by_id(row["id"]) || new
    #don't update id fields
    value_item.attributes = row.to_hash
    value_item.save!
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
