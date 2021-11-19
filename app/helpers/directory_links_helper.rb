module DirectoryLinksHelper

  def env_dig(arg)
    if Rails.env.development?
      Rails.application.credentials[arg.to_s.to_sym]
    else
      ENV["#{arg}"]
    end
  end

end
