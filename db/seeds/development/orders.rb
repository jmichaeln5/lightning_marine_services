def create_vendor_or_puchasher_records(model_name, amount)
  model_klass = model_name.classify.constantize
  amount.times do
    record = model_klass.new(name: Faker::Company.unique.name )
    if record.save
      puts "#{model_name.capitalize} #{record.id} created\n#{record.inspect}\n\n"
    else
      puts "Invalid #{model_name.capitalize} \n#{record.inspect}\nCould not save #{model_name.capitalize}\n\n"
    end
  end
end

def create_orders(orders_to_create)
  def return_amount_of_records_for(model_name) model_name.classify.constantize.all.count end
  vendor_record_amount =  return_amount_of_records_for("vendor")
  purchaser_record_amount =  return_amount_of_records_for("purchaser")

  create_vendor_or_puchasher_records('purchaser', rand(25..100)) unless purchaser_record_amount > 0
  create_vendor_or_puchasher_records('vendor', rand(75..200)) unless vendor_record_amount > 0

  orders_to_create.times do
    archived_options = [true, false]

    order_delivery_date = Faker::Date.between(from: '2017-01-23', to: Time.now)
    order_recieval_date = Faker::Date.between(from: order_delivery_date.prev_month, to: order_delivery_date)

    order = Order.new(
      purchaser_id: "#{Purchaser.all.ids.sample}",
      vendor_id: "#{Vendor.all.ids.sample}",
      po_number: "#{Faker::Number.unique.within(range: 1000..9999999999)}",
      courrier: "#{['Fedex', 'UPS', 'USPS', 'DHL'].sample}",
      date_recieved:"#{order_recieval_date.strftime("%Y-%m-%d")}",
      archived:  archived_options.sample
    )

    if [true, false, false].sample == true
      rand_order_depts = ["deck", "hull", "nav bridge", "bridge", "cargo hood", "forecastle", "upper hold", "upper deck", "main deck", "derrick", "deckhouse", "3 hold", "chain locker"]

      rand_order_depts_arr = []
      rand_order_depts.each do |dept|
        dept = dept.capitalize if [true, false].sample
        dept = dept.upcase if [true, true, false].sample
        rand_order_depts_arr << dept
      end
      rand_order_depts = rand_order_depts_arr

      order.dept = rand_order_depts.sample
    end

    order.date_delivered = "#{order_delivery_date.strftime("%Y-%m-%d")}" if [true, false].sample == true

    def return_false_by_odds(amount)
      likely_false_arr = []
      likely_false_arr << true
      amount.times do likely_false_arr << false end
      return likely_false_arr.sample
    end

    def return_order_content_amount_as_str
      order_content_amount = rand(0..15).to_s
      order_content_amount = 0 if return_false_by_odds(3)
      if order_content_amount == 0
        return nil
      else
        sm_order_content_amount = rand(1..9).to_s
        additional_desc = ["+SM", "+ sm", "OV", "+ov", " + ov"  ].sample
        order_content_amount += "#{sm_order_content_amount}#{additional_desc}"  if return_false_by_odds(30) == true
        return order_content_amount
      end
    end

    other_desc = return_false_by_odds(50) ?  Faker::Lorem.sentence(word_count: rand(1..9)) : nil

    order.build_order_content(
      box: return_order_content_amount_as_str,
      crate: return_order_content_amount_as_str,
      pallet: return_order_content_amount_as_str,
      other_description: other_desc
    )

    order.save ? return_msg = "Order #{order.id} created\n#{order.inspect}" : return_msg = "Invalid Order\n#{order.inspect}\nCould not save Order"
    puts "\n\n#{return_msg}\n\n"
  end
end

rand_amount = rand(150..300)
create_orders(rand_amount)

Order.search_index.delete
Order.reindex
