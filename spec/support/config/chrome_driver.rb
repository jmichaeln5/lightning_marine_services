puts "\n\n"
puts ("*"*33)
puts "rspec feature/system tests have been configured to run with selenium_chrome_headless driver by default"
puts "to run tests with head-full driver run the following command:"
puts "$ HEAD=true bundle exec rspec spec"
puts ("*"*33 + "\n\n")

RSpec.configure do |config|
  config.before(:each) do
    if  ENV['HEAD'] == 'true'
      Capybara.current_driver = :selenium_chrome
    else
      Capybara.current_driver = :selenium_chrome_headless
    end
  end
end
