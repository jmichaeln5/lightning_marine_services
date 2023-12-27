class PackagingMaterial < ApplicationRecord
  include Packageables

  attribute :type_name, :string, default: model_name.human

  # validates :description, presence: { message: "cannot be blank when packaging material type 'Other'" }, if: :non_specified_type?

  def self.types
    PackagingMaterial::Packageable::TYPES
  end

  def self.humanized_types
    PackagingMaterial::Packageable::HUMANIZED_TYPES
  end

  def self.types_options
    type_options_arr = Array.new
    self.types.map { |packaging_material_type|
      type_options_arr.push [(packaging_material_type.delete_prefix "PackagingMaterial::"), packaging_material_type]
    }
    type_options_arr
  end

  # def non_specified_type?
  #   (self.type.in? (PackagingMaterial::Packageable::TYPES - ["PackagingMaterial::Other"])) == false
  # end

  delegate :types, :humanized_types, :types_options, to: :class
end
