if Rails.env.development?
  stop_dev_server = 'cat tmp/pids/server.pid | xargs -n1 -I pid kill -9 pid'
  start_dev_server = 'rails s'
  cmd = "#{stop_dev_server} && #{start_dev_server}"
else
  cmd = 'heroku restart -a lightningmarineservice'
end

system(cmd)
