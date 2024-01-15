return true if Rails.env.production?

seed_env = Rails.env.to_s.dup.downcase

if seed_env.in? %w(development test)
  env_seeds_dir = Rails.root.join("db/seeds/#{seed_env}")
  if Dir.exists? env_seeds_dir
    Dir.glob("#{env_seeds_dir}/*.rb") do |seed|
      load seed
    end
  end
end
