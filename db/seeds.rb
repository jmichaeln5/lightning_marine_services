# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def is_nil_and_zero(data)
   data.blank? || data == 0
end

5.times do
  purchaser = Purchaser.create(name: Faker::Book.title.to_s)
end

5.times do
  vendor = Vendor.create(name: Faker::Book.title.to_s)
end


if  ( User.any? == (false || nil) ) || ( (User.all.count < 1) && (User.all.count < 5) )
# if (User.all.count < 1) && (User.all.count < 5)
  admin_user = User.new(
      id: 1,
      first_name: 'Admin',
      last_name: "User",
      phone_number: "954"+[*0..3, *0..4].sample(7).join,
      email: "admin@gmail.com",
      username: "adminuser",
      password: '123456',
      password_confirmation: "123456"
  )
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
  puts "*"*20
  puts "#{admin_user.username} created."
  puts "*"*20
  puts "#{admin_user.inspect}"
  puts "*"*20
  puts " "
  puts "*"*20
  puts "#{sample_user.username} created."
  puts "*"*20
  puts "#{sample_user.inspect}"
  puts "*"*20
  puts " "

  (3..5).each do |id|
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
      user.skip_confirmation!
      user.save
      puts "*"*20
      puts "#{user.username} created."
      puts "*"*20
      puts "#{user.inspect}"
      puts "*"*20
      puts " "
  end
end

rand(3..10).times do
    # purchaser = Purchaser.create(name: Faker::Book.title)
    purchaser = Purchaser.create(name: Faker::Company.name )
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



rand(1..15).times do
  # vendor = Vendor.create(name: Faker::Book.title)
  vendor = Vendor.create(name: Faker::Company.name )
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


rand(60..100).times do
  order_id = is_nil_and_zero(Order.last) ? 1 : (Order.last.id + 1)
  order = Order.new

  params =  {order: {"id"=> "#{order_id}", "purchaser_id"=> "#{Purchaser.all.ids.sample}", "vendor_id"=> "#{Vendor.all.ids.sample}", "dept"=>"", "po_number"=> "#{Faker::Company.sic_code}", "courrier"=> "#{['Fedex', 'UPS', 'USPS', 'DHL'].sample}", "date_recieved"=>"#{Faker::Date.between(from: '2021-01-23', to: '2021-09-25')}", "date_delivered"=>"", "order_content_attributes"=>{"box"=> "#{rand(0..29)}", "crate"=>"#{rand(0..25)}", "pallet"=>"#{rand(0..10)}", "other"=>"#{rand(0..10)}", "other_description"=>""}}}

  order.update params[:order]

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
puts "*"*20
puts "*"*20
puts "*"*20
puts " "
puts " "

ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
