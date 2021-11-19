require 'digest'

desc 'Create Roles in app (adds to first user)'
task :create_roles => :environment do

  admin = Role.where(name: 'admin').first_or_create
  customer = Role.where(name: 'customer').first_or_create
  staff = Role.where(name: 'staff').first_or_create

end
