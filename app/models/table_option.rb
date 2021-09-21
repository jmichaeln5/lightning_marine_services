class TableOption < ApplicationRecord
  RESOURCE_TYPES = ['Order', 'Vendor', 'Purchaser']

  belongs_to :user

  # validate :validate_amount_of_table_options_for_user
  validate :validate_amount_of_table_options_for_user, :validate_uniq_resource_for_table_option

  private

  def validate_amount_of_table_options_for_user
     if self.user.table_options.size > 3
      self.errors.add(:base, "You can only have 3 Settings for 3 Tables: Orders, Ships, and Vendors")
      throw(:abort)
    end
  end

  def validate_uniq_resource_for_table_option
    # byebug

    self.user.table_options.each do |option|
      if option.resource_table_type.include? self.resource_table_type
        self.errors.add(:base, "You already set Table Options for #{self.resource_table_type}. Please update existing options or delete settings for another table.")
        throw(:abort)
      end
    end

  end

end
