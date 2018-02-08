Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

$redis = Redis.new(url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}")

schedule_file = File.join(File.dirname(__FILE__), '../sidekiq_schedule.yml')
if File.exists?(schedule_file)
  sidekiq_cron = YAML.load_file(schedule_file)
  Sidekiq::Cron::Job.load_from_hash sidekiq_cron
end
