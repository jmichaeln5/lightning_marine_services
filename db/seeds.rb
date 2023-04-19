current_env_str = Rails.env.to_s.downcase

in_valid_seed_env = false
valid_seed_env_str = false

if ('development').in? current_env_str
  in_valid_seed_env = true
  valid_seed_env_str = 'development'
end

if ('test').in? current_env_str
  in_valid_seed_env = true
  valid_seed_env_str = 'test'
end

if !(valid_seed_env_str == 'development') || (valid_seed_env_str == 'test')
  in_valid_seed_env = false
  valid_seed_env_str = false
end

if in_valid_seed_env == true
  seed_dir_for_env = "db/seeds/#{current_env_str}"
  current_env_seeds_dir = Rails.root.join(seed_dir_for_env)
  env_has_seed_files =  Dir.exists? current_env_seeds_dir

  return unless (valid_seed_env_str == 'development') || (valid_seed_env_str == 'test')

  Dir.glob("#{current_env_seeds_dir}/*.rb") do |seed|
    load seed
  end

end
