class OrderValidator < ActiveModel::Validator
  delegate :packaging_materials_error_message, :packaging_materials_error_attribute, :packaging_materials_error_type, to: :class

  def self.packaging_materials_error_message
    "Packaging materials can't be blank."
  end

  def self.packaging_materials_error_attribute
    :base
  end

  def self.packaging_materials_error_type
    :packaging_materials_blank
  end

  def validate(record)
    validate_resourceables(record)
    validate_courrier(record)
    validate_packaging_materials(record)
  end

  def validate_courrier(record)
    record.errors.add(:courrier, :blank) if record.courrier.blank?
  end

  def validate_resourceables(record)
    record.resourceables.each do |resourceable|
      _resourceable = record.send(resourceable)
      record.errors.add(resourceable, "required")  if _resourceable.nil?
    end
  end

  def validate_packaging_materials(record)
    was_created_before = record.created_before_packaging_materials_implementation_date? == true
    was_recieved_before = record.recieved_before_packaging_materials_implementation_date? == true

    unless [was_created_before, was_recieved_before].include? true
      add_packaging_materials_error(record) if add_packaging_materials_error?(record)
    end
  end

  private
    def add_packaging_materials_error?(record)
      return false if record.errors.where(packaging_materials_error_attribute, packaging_materials_error_type).any?

      return true if record.order_content.nil?
      return true if (record.has_packaging_materials? == false)
    end

    def add_packaging_materials_error(record, _packaging_materials_error_message = packaging_materials_error_message)
      record.errors.add(:base, :packaging_materials_blank, message: _packaging_materials_error_message)
    end
end
