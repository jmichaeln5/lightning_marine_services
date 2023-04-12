def create_purchasers(purchasers_to_create)
  purchasers_to_create.times do
    purchaser = Purchaser.new(name: Faker::Company.unique.name )
    if purchaser.save
      puts "Purchaser #{purchaser.id} created\n#{purchaser.inspect}\n\n"
    else
      puts "Invalid Purchaser\n#{purchaser.inspect}\nCould not save Purchaser\n\n"
    end
  end
end

rand_amount = rand(3..5)
# rand_amount = rand(30..50)
create_purchasers(rand_amount)

# Purchaser.reindex
