require 'faker'

desc 'Create Sample Vendors'
task :create_vendors => :environment do

  rand(25..40).times do
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

  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
  Vendor.reindex

end
