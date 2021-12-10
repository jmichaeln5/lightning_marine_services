require 'faker'

desc 'Create Sample Purchasers'
task :create_purchasers => :environment do

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


  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }

  Purchaser.reindex
end
