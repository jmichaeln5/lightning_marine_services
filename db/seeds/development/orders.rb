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

  create_vendor_or_puchasher_records("vendor", rand(1..30)) unless vendor_record_amount > 0
  create_vendor_or_puchasher_records("purchaser", rand(1..30)) unless purchaser_record_amount > 0

  orders_to_create.times do
    order_class_false_or_nil = [true, false]
    archived_options = [true, false]

    order_delivery_date = Faker::Date.between(from: '2017-01-23', to: Time.now)
    order_recieval_date = Faker::Date.between(from: order_delivery_date.prev_month, to: order_delivery_date)

    order = Order.new(
      purchaser_id: "#{Purchaser.all.ids.sample}",
      vendor_id: "#{Vendor.all.ids.sample}",
      po_number: "#{Faker::Number.unique.within(range: 100..9999999999)}",
      courrier: "#{['Fedex', 'UPS', 'USPS', 'DHL'].sample}",
      date_recieved:"#{order_recieval_date.strftime("%Y-%m-%d")}",
      archived:  archived_options.sample
    )

    order.dept = "#{Faker::Job.field}" if [true, false].sample == true
    order.date_delivered = "#{order_delivery_date.strftime("%Y-%m-%d")}" if [true, false].sample == true

    order.build_order_content(
      box: "#{rand(0..15)}",
      crate:"#{rand(0..20)}",
      pallet:"#{rand(0..10)}",
      other:"#{rand(0..5)}",
      other_description: 'test data'
    )

    order.save ? return_msg = "Order #{order.id} created\n#{order.inspect}" : return_msg = "Invalid Order\n#{order.inspect}\nCould not save Order"

    puts "\n\n#{return_msg}\n\n"
  end
end

rand_amount = rand(150..300)
create_orders(rand_amount)
