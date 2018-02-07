# frozen_string_literal: true

require 'dotenv/load'
require 'capybara/dsl'
require_relative '../services/dashboard_kudos_service.rb'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

class DashboardKudosWorker
  include Sidekiq::Worker

  def perform
    p 'Starting kudos worker'
    DashboardkKudosService.new.kudos
    p 'Ending kudos worker'
  end
end
