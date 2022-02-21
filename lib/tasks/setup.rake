namespace :db do
  desc 'DB Setup for all envs'
  task :setup do

    if Rails.env.development?
      Rake::Task["create_admin_if_nil"].execute
      Rake::Task["create_roles"].execute
      Rake::Task["create_default_directory_links"].execute
      Rake::Task["create_users"].execute
      Rake::Task["create_purchasers"].execute
      Rake::Task["create_vendors"].execute
      Rake::Task["create_orders"].execute
    end

    if Rails.env.production?
      Rake::Task["create_admin_if_nil"].execute
      Rake::Task["create_roles"].execute
      Rake::Task["create_default_directory_links"].execute
    end

    if Rails.env.test?
      Rake::Task["create_admin_if_nil"].execute
      Rake::Task["create_roles"].execute
      Rake::Task["create_default_directory_links"].execute
    end

    ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
  end
end
