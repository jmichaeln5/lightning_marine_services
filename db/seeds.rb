if !Rails.env.production?
  valid_seed_env = Rails.env.to_s.downcase

  in_valid_seed_env = false
  in_valid_seed_env = true if valid_seed_env == 'development'
  in_valid_seed_env = true if valid_seed_env == 'test'

  if in_valid_seed_env == true
    seed_dir_for_env = "db/seeds/#{valid_seed_env}"

    current_env_seeds_dir = Rails.root.join(seed_dir_for_env)
    env_has_seed_files =  Dir.exists? current_env_seeds_dir

    Dir.glob("#{current_env_seeds_dir}/*.rb") do |seed|
      load seed
    end
  end

end
