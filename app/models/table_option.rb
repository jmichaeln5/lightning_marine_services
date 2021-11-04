class TableOption < ApplicationRecord
  belongs_to :user

  # validate :validate_uniq_table_option, on: [:create, :update]
  before_create :before_create_validations
  before_update :before_update_validations

  def selected_options
    self.option_list.present? ? ActiveSupport::JSON.decode(self.option_list) : 0
  end

  def controller_name_and_action
    "#{self.resource_table_type.pluralize}" + "#" + "#{self.resource_table_action}".downcase
  end

  def belongs_to_user?
    true
  end

  private

  def before_create_validations
    validate_uniq_table_option
    validate_table_option_option_list
  end

  def before_update_validations
     validate_table_option_option_list
  end

  def validate_uniq_table_option
    if self.user.table_options.any?
      new_table_option_controller_name_and_action = "#{self.resource_table_type.pluralize}" + "#" + "#{self.resource_table_action}".downcase

      self.user.table_options.each do |record|

        records_controller_name_and_action = "#{record.resource_table_type.pluralize}" + "#" + "#{record.resource_table_action}".downcase

        if records_controller_name_and_action == new_table_option_controller_name_and_action
          self.errors.add(:base, "You already have table options for #{self.resource_table_type}. Please update or remove existing table options for #{self.resource_table_type.capitalize.pluralize}.")
          throw(:abort)
        end
      end

    end
  end

  def validate_table_option_option_list
    if self.option_list.blank?
      self.errors.add(:base, "Table option's columns cannot be blank, please selected at least 3 columns to display.")
      throw(:abort)
    elsif self.selected_options.size < 3
      self.errors.add(:base, "You must have at least 3 columns selected to display.")
      throw(:abort)
    end
  end

end
