# vendors_to_create = rand(25..75)
vendors_to_create = rand(9..25)
purchasers_to_create = (vendors_to_create / 2).round(1)
orders_to_create = vendors_to_create * 5

vendors_to_create.times do
  Vendor.create name: Faker::Company.unique.name
end

purchasers_to_create.times do
  Purchaser.create name: Faker::Company.unique.name
end

def random_odds(truthy_odds = 3, falsey_odd = 10); odds = Array.new; (truthy_odds.times do; odds.push true; end); (falsey_odd.times do; odds.push false; end); odds.sample; end

def random_dept
  dept = ["deck", "hull", "nav bridge", "bridge", "cargo hood", "forecastle", "upper hold", "upper deck", "main deck", "derrick", "deckhouse", "3 hold", "chain locker"].sample
  dept.upcase! if random_odds(10,10)
  dept
end

def random_order_attributes
  date_recieved, date_delivered = nil
  if ((random_odds(truthy_odds = 5, falsey_odd = 2)) == true)
    date_delivered = Faker::Date.between(from: '2017-01-23', to: Time.now)
    date_recieved = Faker::Date.between(from: date_delivered.prev_month, to: date_delivered)
    date_delivered = date_delivered.strftime("%Y-%m-%d")
    date_recieved = date_recieved.strftime("%Y-%m-%d")
  else
    date_recieved = Faker::Date.between(from: '2017-01-23', to: Time.now)
    date_recieved = date_recieved.strftime("%Y-%m-%d")
  end

  {
    dept: random_dept,
    purchaser: Purchaser.all.sample,
    vendor: Vendor.all.sample,
    po_number: Faker::Number.number(digits: rand(7..11)),
    courrier: ['Fedex', 'UPS', 'USPS', 'DHL'].sample,
    date_recieved: date_recieved,
    date_delivered: date_delivered,
    order_content_attributes: [],
  }
end


def rand_order_content_amt; "#{rand(0..7)}"; end;

def random_order_content_attributes
  other, other_description = nil
  other = [nil, nil, nil, nil, nil, nil, nil, nil, rand(0..7).to_s].sample

  if [true, false].sample == true
    other_description = Faker::Lorem.words(number: rand(3..5)).join(" ") unless other.nil?
  end

  box = rand_order_content_amt.to_s
  crate = [nil, nil, rand_order_content_amt, rand_order_content_amt].sample
  pallet = [nil, nil, nil, rand_order_content_amt, rand_order_content_amt].sample

  {
    box: box.to_s,
    crate: crate,
    pallet: pallet,
    other: other,
    other_description: other_description,
    # packaging_materials_attributes: [
    #   # type:
    # ]
  }
end

def random_order_attributes_with_order_content
  attrs = random_order_attributes
  attrs[:order_content_attributes]
  attrs[:order_content_attributes] = random_order_content_attributes
  attrs
end

orders_to_create.times do
  order = Order.new random_order_attributes_with_order_content

  if order.order_content.box.to_i > 0
    if (random_odds(truthy_odds = 3, falsey_odd = 10) == true)
      new_val = ["ov", "OV", "xl", "XL"].sample
      new_val = "+ #{rand(1..3)}#{new_val}"
      order.order_content.box = "#{order.order_content.box} #{new_val}"
    end
  end

  if order.save
    puts "\n\n"
    "Order #{order.id} created"
    puts "#{' '*3} Order:\n#{' '*3}#{order.inspect}\n"
    puts "#{' '*3} OrderContent:\n#{' '*3}#{order.order_content.inspect}"
    puts "\n\n"
  else
    puts "Invalid Order\n#{order.inspect}\nCould not save Order"
  end
end

Order.search_index.delete
Order.reindex
