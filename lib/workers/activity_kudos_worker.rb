# frozen_string_literal: true

require 'dotenv/load'
require 'capybara/dsl'
require_relative '../services/activity_kudos_service.rb'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

class ActivityKudosWorker
  include Sidekiq::Worker

  def perform(object_id)
    p 'Starting activity kudos worker'
    ActivityKudosService.new.kudos(object_id)
    p 'Ending activity kudos worker'
  end
end
