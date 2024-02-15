rand_vendor_amount_range = (60..100)
@vendors_to_create = (Vendor.all.size < 1) ? rand(rand_vendor_amount_range) : Vendor.all.size
@purchasers_to_create = (Purchaser.all.size < 1) ? (@vendors_to_create / 3).round(1) : Purchaser.all.size

@orders_to_create =  @vendors_to_create * 20
@orders_before_packageables = (@orders_to_create / 3).round(1)
@orders_after_packageables = @orders_to_create - @orders_before_packageables

@vendors_to_create.times do
  Vendor.create name: Faker::Company.unique.name
end

@purchasers_to_create.times do
  Purchaser.create name: Faker::Company.unique.name
end

if Order.all.size > 0
  Order.search_index.delete
end

def odds_boolean(truthy_odds = 1, falsey_odds = 3)
  odds_array = Array.new
  truthy_odds.times do odds_array.push(true) end
  falsey_odds.times do odds_array.push(false) end

  return odds_array.sample
end

def set_order_courrier(order, courrier = nil)
  courrier = ['Fedex', 'UPS', 'USPS', 'DHL'].sample
  order.courrier = courrier
end

def set_order_po_number(order, po_number = nil)
  po_number = Faker::Number.number(digits: rand(7..11)) unless (po_number.nil? && odds_boolean(1, 15))
  order.po_number = po_number
end

def set_order_dept(order, dept = nil)
  unless dept.nil?
    dept = odds_boolean(1,19) ? ["deck", "hull", "nav bridge", "bridge", "cargo hood", "forecastle", "upper hold", "upper deck", "main deck", "derrick", "deckhouse", "3 hold", "chain locker"].sample : nil

    dept = dept.nil? ? nil : (dept.upcase if odds_boolean(5, 1))
  end
  order.dept = dept
end

def set_order_date_delivered(order, date_delivered = nil)
  return (order.date_delivered = date_delivered) unless date_delivered.nil?

  before_packageables = @orders_before_packageables >= 1
  (truthy_odds, falsey_odds = 10, 1) if before_packageables
  (truthy_odds, falsey_odds = 1, 1) if !before_packageables

  return order unless odds_boolean(truthy_odds, falsey_odds)

  date_delivered_to = PackageablesEligibility::PACKAGING_MATERIALS_IMPLEMENTATION_DATE
  if before_packageables
    date_delivered = Faker::Date.between(from: (date_delivered_to - 5.years), to: (date_delivered_to - 3.months))
  else
    date_delivered = Faker::Date.between(from: date_delivered_to, to: Time.now)
  end

  order.date_delivered = date_delivered
end

def set_order_date_recieved(order, date_recieved = nil)
  date_recieved = Faker::Date.between(from: order.date_delivered.prev_week, to: order.date_delivered) if order.date_delivered?
  order.date_recieved = date_recieved

  return order unless order.date_recieved.nil?

  date_delivered_to = PackageablesEligibility::PACKAGING_MATERIALS_IMPLEMENTATION_DATE

  before_packageables = @orders_before_packageables >= 1

  date_recieved = Faker::Date.between(from: (date_delivered_to - 5.years), to: date_delivered_to) if before_packageables
  date_recieved = Faker::Date.between(from: (date_delivered_to), to: Time.now) if !before_packageables

  order.date_recieved = date_recieved if odds_boolean(9, 1)
end

def set_order_status(order)
  status = "delivered" if order.date_delivered?

  if !order.date_delivered?
    case [true, true, true, false].sample
    when true
      status = "active"
    else
      status = ["partially_delivered", "hold"].sample
    end
  end
  order.status = status
end

def set_order_order_sequence(order)
  purchaser_active_orders = order.purchaser.orders.active
  seq = 1

  purchaser_active_orders.each do |ord|
    iSeq = ord.try(:order_sequence)|| 0
    if iSeq >= seq
      seq = iSeq + 1
    end
  end
  order.order_sequence = seq
end

def new_order_packaging_material(order_content, packaging_material_type)
  packaging_material = order_content.packaging_materials.build
  packaging_material.type = packaging_material_type

  if order_content.order.status == "partially_delivered"
    status = "hold"
  else
    packaging_material.status = order_content.order.status
  end
end

if Order.all.size > 0
  Order.search_index.delete
end

@orders_before_packageables.times do
  order = Order.new(
    purchaser_id: Purchaser.ids.sample,
    vendor_id: Vendor.ids.sample,
  )
  set_order_dept(order); set_order_po_number(order); set_order_courrier(order); set_order_date_delivered(order); set_order_date_recieved(order)
  order.archived = order.date_delivered?
  set_order_status(order); set_order_order_sequence(order)

  order_content = order.build_order_content
  order_content.box    = rand(1..7) if odds_boolean
  order_content.crate  = rand(1..7) if odds_boolean
  order_content.pallet = rand(1..7) if odds_boolean
  order_content.box    = rand(1..3) if ((order_content.box.nil? && order_content.crate.nil? && order_content.pallet.nil?) == true)

  order.save(validate: false)

  @orders_before_packageables -= 1
  puts "\n\n"; puts "created order #{order.id}"; puts "remaining @orders_before_packageables to create: #{@orders_before_packageables}"; puts "remaining @orders_after_packageables to create: #{@orders_after_packageables}"; puts "\n\n";
end

Order.search_index.delete

@orders_after_packageables.times do
  order = Order.new(
  purchaser_id: Purchaser.ids.sample,
  vendor_id: Vendor.ids.sample,
  )
  set_order_dept(order)
  set_order_po_number(order)
  set_order_courrier(order)
  set_order_date_delivered(order)
  set_order_date_recieved(order)
  order.archived = order.date_delivered?
  set_order_status(order)
  set_order_order_sequence(order)

  order_content = order.build_order_content

  if odds_boolean
    rand(1..7).times do
      new_order_packaging_material(order_content, "PackagingMaterial::Box")
    end
  end

  if odds_boolean
    rand(1..7).times do
      new_order_packaging_material(order_content, "PackagingMaterial::Crate")
    end
  end

  if odds_boolean
    rand(1..7).times do
      new_order_packaging_material(order_content, "PackagingMaterial::Pallet")
    end
  end


  order_with_packaging_materials_attributes = order.with_packaging_materials_attributes

  if order_with_packaging_materials_attributes[:order_content_attributes][:packaging_materials_attributes].blank?
    rand(1..3).times do
      new_order_packaging_material(order_content, "PackagingMaterial::Box")
    end
  end

  order = Order.new(order_with_packaging_materials_attributes)

  if order.save
    @orders_after_packageables -= 1
    puts "\n\n"; puts "created order #{order.id}"; puts "remaining @orders_before_packageables to create: #{@orders_before_packageables}"; puts "remaining @orders_after_packageables to create: #{@orders_after_packageables}"; puts "\n\n";

    # puts "\n\n"
    # puts "created order #{order.id}"
    # puts "remaining @orders_before_packageables to create: #{@orders_before_packageables}"
    # puts "remaining @orders_after_packageables to create: #{@orders_after_packageables}"
    # puts "\n\n"
  end
end

Order.search_index.delete
Order.reindex
