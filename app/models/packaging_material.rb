class PackagingMaterial < ApplicationRecord
  include Packageables

  attribute :type_name, :string, default: model_name.human

  validates :description, presence: { message: "cannot be blank when packaging material type 'Other'" }, if: :non_specified_type?

  def non_specified_type?
    # (self.type.in? (PackagingMaterial::Packageable::TYPES - ["PackagingMaterial::Other"])) == false
    !(self.type.in? (PackagingMaterial::Packageable::TYPES - ["PackagingMaterial::Other"]))
  end

  # delegate :types, :humanized_types, :types_options, to: :class
end
