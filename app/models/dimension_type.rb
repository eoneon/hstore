class DimensionType < ActiveRecord::Base
  has_many :fields, class_name: "ItemField", dependent: :destroy
  accepts_nested_attributes_for :fields, allow_destroy: true

  def flat_dimension_types
    DimensionType.all.map {|dim| dim unless dimension_type.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end

  def sculpture_dimension_types
    DimensionType.all.map {|dim| dim if dimension_type.name.split(" & ")[-1] == "weight"}.reject {|dim| dim.nil?}
  end
end
