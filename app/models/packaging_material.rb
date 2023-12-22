class PackagingMaterial < ApplicationRecord
  include Packageables

  validates :description, presence: { message: "required when packaging material type 'Other'" }, if: :default_type?

  private
    def default_type?
      self.type == 'PackagingMaterial'
    end
end
