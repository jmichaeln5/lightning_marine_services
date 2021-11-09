if Rails.env.development? == true # COMMENT OUT UNLESS BEFORE Prod PUSH!!!
  if  ( (User.all.count <= 1) && (User.all.count < 2) )

    admin_user = User.new( id: 1, first_name: 'Admin', last_name: "User", phone_number: "954"+[*0..3, *0..4].sample(7).join, email: "admin@gmail.com", username: "adminuser", password: '123456', password_confirmation: "123456")

    admin_user.add_role "admin"
    admin_user.skip_confirmation!

    admin_user.save

    sample_user = User.new(
        id: 2,
        first_name: 'Timmy',
        last_name: "Tables",
        phone_number: "954"+[*0..3, *0..4].sample(7).join,
        email: "timmytables@gmail.com",
        username: "timmyt",
        password: '123456',
        password_confirmation: "123456"
    )
    sample_user.add_role "admin"
    sample_user.skip_confirmation!
    sample_user.save

    puts " "
    puts " "
    puts "*"*50
    puts "*"*50
    puts " "
    puts "Creating Users..."
    puts " "
    puts "*"*50
    puts "*"*50
    puts " "
    puts " "
    # puts "*"*20
    # puts "#{admin_user.username} created."
    # puts "*"*20
    # puts "#{admin_user.inspect}"
    # puts "*"*20
    # puts " "
    puts "*"*20
    puts "#{sample_user.username} created."
    puts "*"*20
    puts "#{sample_user.inspect}"
    puts "*"*20
    puts " "

    all_available_roles = Role.defined_roles
    limited_roles = ["staff", "customer"]

    # (3..30).each do |id|
    (3..12).each do |id|
    # (3..4).each do |id|
        # id = User.last.id + 1

        user = User.new(
          id: id,
          first_name: 'User',
          last_name: "#{id.humanize.capitalize}",
          phone_number: "305"+[*0..3, *0..4].sample(7).join,
          email: "user#{id}@gmail.com",
          username: "user#{id.humanize}",
          password: '123456',
          password_confirmation: "123456"
        )

        if Role.first.users.count > 5
           assign_roles = all_available_roles
         else
           assign_roles = limited_roles
         end

        user.add_role assign_roles.sample

        user.skip_confirmation!
        user.save
        puts "*"*20
        puts "#{user.username} created."
        puts "*"*20
        puts "#{user.username} role(s): #{user.roles.map {|r| r.name}}"
        puts "*"*20
        puts "#{user.inspect}"
        puts "*"*20
        puts " "
    end
  end

  # rand(3..10).times do
  rand(25..40).times do
      purchaser = Purchaser.create(name: Faker::Company.unique.name )
      puts " "
      puts "*"*20
      puts "#{purchaser} created."
      puts "*"*20
      puts "#{purchaser.inspect}"
      puts "*"*20
      puts " "
  end

  puts " "
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts "#{Purchaser.all.count} Purchasers(Ships) created."
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts " "

  # rand(7..15).times do
  rand(7..25).times do
    vendor = Vendor.create(name: Faker::Company.unique.name )
      puts " "
      puts "*"*20
      puts "#{vendor} created."
      puts "*"*20
      puts "#{vendor.inspect}"
      puts "*"*20
      puts " "
  end

  puts " "
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts "#{Vendor.all.count} Vendors created."
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts " "

  start_ids_from = Order.last ? ( Order.last.id + 1) : 1
  # start_ids_from = Order.last.id + 1

  # random_order_count = rand(100..300)
  # random_order_count = rand(300..500)
  # random_order_count = rand(500..1000)
  random_order_count = rand(750..1500)
  # random_order_count = rand(3000..10000)
  (start_ids_from..random_order_count).each do |id|

    order_class_false_or_nil = [true, false]
    archived_options = [true, false]

    order_delivery_date = Faker::Date.between(from: '2017-01-23', to: Time.now)
    order_recieval_date = Faker::Date.between(from: order_delivery_date.prev_month, to: order_delivery_date)

    order = Order.new(
      id: id,
      purchaser_id: "#{Purchaser.all.ids.sample}",
      vendor_id: "#{Vendor.all.ids.sample}",
      po_number: "#{Faker::Number.unique.within(range: 100..9999999999)}",
      courrier: "#{['Fedex', 'UPS', 'USPS', 'DHL'].sample}",
      date_recieved:"#{order_recieval_date.strftime("%Y-%m-%d")}",
      archived:  archived_options.sample
    )

    if [true, false].sample == true
      order.dept = "#{Faker::Job.field}"
    end

    if order.archived == true
      order.date_delivered = "#{order_delivery_date.strftime("%Y-%m-%d")}"
    end

    order.build_order_content(
      id: id,
      order_id: id,
      box: "#{rand(0..15)}",
      crate:"#{rand(0..20)}",
      pallet:"#{rand(0..10)}",
      other:"#{rand(0..5)}",
      other_description: 'test data'
    )

    order.save

    puts " "
    puts "*"*20
    puts "#{order} created."
    puts "*"*20
    puts "#{order.inspect}"
    puts "#{order.order_content.inspect}"
    puts "*"*20
    puts " "
  end

  puts " "
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts "#{Order.all.count} Orders created."
  puts " "
  puts "#{Order.unarchived.count} Unarchived Orders created."
  puts " "
  puts "#{Order.archived.count} Archived Orders created."
  puts " "
  puts "*"*20
  puts "*"*20
  puts "*"*20
  puts " "
  puts " "

  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }

end
