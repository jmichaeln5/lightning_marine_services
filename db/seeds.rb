seed_dir_for_env = "db/seeds/#{Rails.env}"
current_env_seeds_dir = Rails.root.join(seed_dir_for_env)
env_has_seed_files =  Dir.exists? current_env_seeds_dir

def valid_env
  current_env = Rails.env.upcase
  return true if current_env == "DEVELOPMENT"
  return true if current_env == "TEST"
  return false
end

if valid_env && env_has_seed_files
  Dir.glob("#{current_env_seeds_dir}/*.rb") do |seed|
    load seed
  end
end
