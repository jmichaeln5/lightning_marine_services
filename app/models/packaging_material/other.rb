class PackagingMaterial::Other < PackagingMaterial
  include Packageable

  # validate :blank_description_if_other

  private
    # def blank_description_if_other
    #   errors.add(:description, :blank) if description.blank?
    # end
end
