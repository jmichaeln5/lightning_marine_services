desc 'Creates default directory_links '
task :create_default_directory_links => :environment do
  DirectoryLink.predefined_directory_links

  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
end
