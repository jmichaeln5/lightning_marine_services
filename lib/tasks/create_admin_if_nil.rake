desc 'Create default admin acc if nil using email and pass(env vars in prod)'
task :create_admin_if_nil => :environment do
  if Rails.env.development?
    # admin_email = Rails.application.credentials[:gmail][:GMAIL_SMTP_USER]
    # admin_pass = Rails.application.credentials[:gmail][:GMAIL_SMTP_PASSWORD]
    admin_email = 'admin@gmail.com'
    admin_pass = '123456'
  else
    admin_email = ENV['GMAIL_SMTP_USER']
    admin_pass = ENV['GMAIL_SMTP_PASSWORD']
  end

  admin_user_id = User.last ? ( User.last.id + 1) : 1

  admin_user = User.new( id: admin_user_id, first_name: 'Admin', last_name: "Account", phone_number: "+1(954)-706-2270", email: admin_email, username: "adminuser", password: admin_pass, password_confirmation: admin_pass)

  admin_user.add_role "admin"
  admin_user.skip_confirmation!
  admin_user.save
end
