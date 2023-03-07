def create_user_by_role(users_to_create, role)
  users_to_create.times do
    user_count = 0 if !User.any?
    user_count = User.all.count if User.any?
    user_count += 1

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = "user#{user_count}@example.com"
    username = "#{role.name}_user_#{user_count}"
    phone_number = Faker::PhoneNumber.cell_phone

    user = User.new(first_name:'User',
      last_name: user_count.to_words,
      email:"user#{user_count}@example.com",
      password:"123456",
      phone_number: phone_number,
      username: username
    )
    user.skip_confirmation_notification!
    user.skip_confirmation!

    if role.name != "customer"
      user.remove_role :customer if user.has_role?(:customer)
      user.add_role :admin if role.name == "admin"
      user.add_role :staff if role.name == "staff"
      user.save
    end

    if user.save
      puts "User #{user.id} created\n#{user.inspect}\n\n"
    else
      puts "Invalid User\n#{user.inspect}\nCould not save User\n"
    end

  end
end

Role.generic_roles
Role.generic_roles.each do |role|
  create_user_by_role(10, role)
end
