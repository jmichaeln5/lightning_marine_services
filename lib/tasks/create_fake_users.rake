require 'faker'

desc 'Create Fake Users (skips Devise user confirmation)'
task :create_fake_users => :environment do

  starting_id_to_create = User.last ? ( User.last.id + 1) : 1
  users_to_create = 10
  ending_id_to_create = starting_id_to_create + users_to_create

  puts " "
  puts "#{User.all.count} Users in DB"
  puts " "
  # puts "Last User: " (+ User.last.inspect)
  User.last ? (puts "Last User: " + User.last.inspect) : (puts " ")
  puts " "

  puts "*"*50
  puts " "
  puts "Staarting User's ID to create: #{starting_id_to_create}"
  puts " "
  puts "*"*50
  puts " "

  puts "*"*50
  puts " "
  puts "Creating 10 Users..."
  puts " "
  puts "*"*50
  puts " "


  (starting_id_to_create..ending_id_to_create).each do |id|
        @user = User.new(
            id: id,
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            phone_number: Faker::PhoneNumber.unique.cell_phone,
            email: "user#{id}@gmail.com",
            username: Faker::Internet.unique.username,
            password: '123456',
            password_confirmation: "123456"
        )
        @user.skip_confirmation!
        @user.save
        puts "*"*20
        puts "#{@user.username} created."
        puts "*"*20
        puts "#{@user.inspect}"
        puts "*"*20
        puts " "
    end

    puts "*"*50
    puts " "
    puts "Created #{users_to_create} new users."
    puts " "
    puts "*"*50
    puts " "

    ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }

end
