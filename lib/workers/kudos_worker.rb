# frozen_string_literal: true

require 'dotenv/load'
require 'capybara/dsl'
require_relative '../services/kudos_service.rb'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

class KudosWorker
  include Sidekiq::Worker

  def perform
    p 'Starting kudos worker'
    KudosService.new.kudos
  end
end
