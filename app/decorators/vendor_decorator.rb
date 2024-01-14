class VendorDecorator
  def self.options_for_select(vendor = nil)
    return Vendor.select([:name, :id]).order('UPPER(name)').collect { |vendor| [ vendor.name, vendor.id ] } if vendor.nil?

    return (Vendor.where.not(id: vendor.id).select([:name, :id]).order('UPPER(name)').collect { |vendor| [ vendor.name, vendor.id ] }).prepend([vendor.name, vendor.id])
  end
end
