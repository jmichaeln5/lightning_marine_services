def create_vendors(vendors_to_create)
  vendors_to_create.times do
    vendor = Vendor.new(name: Faker::Company.unique.name )
    if vendor.save
      puts "Vendor #{vendor.id} created\n#{vendor.inspect}\n\n"
    else
      puts "Invalid Vendor\n#{vendor.inspect}\nCould not save Vendor\n\n"
    end
  end
end

rand_amount = rand(3..5)
# rand_amount = rand(30..50)
create_vendors(rand_amount)
# Vendor.reindex
