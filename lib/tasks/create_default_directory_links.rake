desc 'Creates default directory_links '
task :create_default_directory_links => :environment do
  DirectoryLink.predefined_directory_links
end
