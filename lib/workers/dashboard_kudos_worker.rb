# frozen_string_literal: true

require 'sidekiq-scheduler'
require_relative '../services/dashboard_kudos_service.rb'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

class DashboardKudosWorker
  include Sidekiq::Worker

  def perform
    p 'Starting dashboard kudos worker'
    DashboardKudosService.new.kudos
    p 'Ending dashboard kudos worker'
  end
end
