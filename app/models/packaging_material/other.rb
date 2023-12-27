class PackagingMaterial::Other < PackagingMaterial
  include Packageable

  validate :description_if_other

  private
    def description_if_other
      # order.order_content.errors.add(:description, "Description cannot be blank when packaging material type 'Other'") if (self.description.blank? || self.description.nil?)
      order_content.errors.add(:description, "cannot be blank when packaging material type 'Other'") if (self.description.blank? || self.description.nil?)
    end
end
