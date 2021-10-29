class TableOption < ApplicationRecord
  belongs_to :user

  before_create :validate_uniq_table_option, :validate_user_table_options_amount, :validate_table_option_option_list

  before_update :validate_user_table_options_amount, :validate_table_option_option_list


  def selected_options
    self.option_list.present? ? ActiveSupport::JSON.decode(self.option_list) : nil
  end

  def controller_name_and_action
    "#{self.resource_table_type.pluralize}" + "#" + "#{self.resource_table_action}".downcase
  end

  def belongs_to_user?
    true
  end

  private

  def validate_uniq_table_option
    self.user.table_options.each do |option|
      if option.resource_table_type.include? (self.resource_table_type || self.resource_table_action)
        self.errors.add(:base, "You already set Table Options for #{self.resource_table_type}. Please update existing options or delete settings for another table.")
        throw(:abort)
      end
    end
  end

  def validate_user_table_options_amount
    if ((self.user.table_options.present?) && (self.user.table_options.size > 3))
      self.errors.add(:base, "You already have the maximum amount of Table Options")
      throw(:abort)
    end
  end

  def validate_table_option_option_list
    if self.option_list.present? && self.selected_options.size < 3
      self.errors.add(:base, "You must have at least 3 columns selected to display.")
      throw(:abort)
    end
  end

end
