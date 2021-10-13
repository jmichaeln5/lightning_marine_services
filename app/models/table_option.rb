class TableOption < ApplicationRecord
  belongs_to :user

  before_save :validate_amount_of_table_options_for_resource
  before_save :validate_table_option_option_list
  before_create :validate_uniq_resource_for_table_option

  def option_list_arr
    option_list_arr = self.option_list.present? ? ActiveSupport::JSON.decode(self.option_list) : nil
  end

  private

  def validate_amount_of_table_options_for_resource
    if ((self.user.table_options.present?) && (self.user.table_options.size > 3))
      self.errors.add(:base, "You can only have 3 Settings for 3 Tables: Orders, Ships, and Vendors")
      throw(:abort)
    end
  end

  def validate_uniq_resource_for_table_option
    self.user.table_options.each do |option|
      if option.resource_table_type.include? self.resource_table_type
        self.errors.add(:base, "You already set Table Options for #{self.resource_table_type}. Please update existing options or delete settings for another table.")
        throw(:abort)
      end
    end
  end

  def validate_table_option_option_list
    # byebug

    # self.option_list = nil if self.option_list_arr.size < 0

    # option_list_arr.size

    if self.option_list_arr.present? && option_list_arr.size < 3
      self.errors.add(:base, "You must have at least 3 columns selected to display.")
      throw(:abort)
    end

  end

end
