ENV.each { |k, v| env(k, v) }
set :output, { standard: "log/cron.log", error: "log/cron_error.log" }
set :environment, ENV['RAILS_ENV'] || 'development'
every 59.minute do
  rake "counts:update"
end
