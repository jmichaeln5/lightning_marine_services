module AdminHelpers

  def self.get_admin_helpers_users
    autoload :AdminHelpersUsers, "admin_helpers/admin_helpers_users/admin_helpers_users.rb"
    extend AdminHelpersUsers
  end

end
