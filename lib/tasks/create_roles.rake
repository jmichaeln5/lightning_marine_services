require 'digest'

desc 'Create Roles in app (adds to first user)'
task :create_roles => :environment do

  all_available_roles = ["admin", "staff", "customer"]
  all_available_roles_count = all_available_roles.count

  all_available_roles.each do |role|
    user = User.first
    if user.roles.include? role
      puts "User already has role"
    else
      user.add_role role
      puts "Role: #{role.inspect}"
      puts "added to #{user}"
    end
  end
end
