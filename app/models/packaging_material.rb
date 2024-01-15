class PackagingMaterial < ApplicationRecord
  include Packageables

  validates :description, presence: { message: "cannot be blank when packaging material type 'Other'" }, if: :non_specified_type?

  def non_specified_type?
    (self.type.in? (PackagingMaterialDecorator.types - ["PackagingMaterial::Other"])) == false
  end
end
