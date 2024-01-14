class PurchaserDecorator
  def self.options_for_select(purchaser = nil)
    return Purchaser.select([:name, :id]).order('UPPER(name)').collect { |purchaser| [ purchaser.name, purchaser.id ] } if purchaser.nil?

    return (Purchaser.where.not(id: purchaser.id).select([:name, :id]).order('UPPER(name)').collect { |purchaser| [ purchaser.name, purchaser.id ] }).prepend([purchaser.name, purchaser.id])
  end
end
