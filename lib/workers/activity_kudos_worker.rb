# frozen_string_literal: true

require 'sidekiq-scheduler'
require_relative '../services/webdriver/kudos'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

class ActivityKudosWorker
  include Sidekiq::Worker

  def perform(object_id)
    p 'Starting activity kudos worker'
    KudosService.new.kudos_activity(object_id)
    p 'Ending activity kudos worker'
  end
end
