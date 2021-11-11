module AdminHelpersUsers
  def self.admin_helpers_users_yeet_self
    puts 'admin_helpers_users_yeet_self: self yeeeet'
  end

  def self.get_admin_helpers_users_new
    autoload :AdminUsersHelpersNew, "admin_helpers/admin_helpers_users/admin_helpers_users_new.rb"
    extend AdminUsersHelpersNew
  end

  def self.get_admin_helpers_users_create
    autoload :AdminUsersHelpersCreate, "admin_helpers/admin_helpers_users/admin_helpers_users_create.rb"
    extend AdminUsersHelpersCreate
  end

end
