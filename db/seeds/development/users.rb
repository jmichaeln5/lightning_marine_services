users_to_create = 17
last_user_id = User.any? ? User.all.size : 1

def create_user_with_role(role: nil, confirmed: true)
  next_user_id = User.any? ? (User.all.size + 1) : 1
  role ||= Role.find_by_name("customer")
  role_name = role.name

  user = User.new name: "User #{next_user_id.to_words.capitalize}", email:"user#{next_user_id}@example.com", password:"123456", phone_number: Faker::PhoneNumber.cell_phone, username: "#{role.name}_user_#{next_user_id}"

  user.skip_confirmation_notification!
  user.skip_confirmation!

  user.add_role role.name unless user.roles.include? role

  if user.save
    puts "User #{user.id} created\n#{user.inspect}\nRole: #{role_name}\n\n"
  else
    "Invalid User\n#{user.inspect}\nCould not save User\n"
  end
end

users_to_create_per_role = ((users_to_create / Role.generic_roles.size).round(0))

Role.generic_roles.each do |role|
  users_to_create_per_role.times do
    create_user_with_role(role: role, confirmed: true)
  end
end
