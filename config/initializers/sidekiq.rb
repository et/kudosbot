def configure_for_production
  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
  end

  $redis = Redis.new(url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}")
end

if ENV['RACK_ENV'] === 'production'
  configure_for_production
end