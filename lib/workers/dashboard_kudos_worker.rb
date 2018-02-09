# frozen_string_literal: true

require 'sidekiq-scheduler'
require_relative '../services/dashboard_kudos_service.rb'

class DashboardKudosWorker
  include Sidekiq::Worker

  def perform
    p 'Starting dashboard kudos worker'
    DashboardKudosService.new.kudos
    p 'Ending dashboard kudos worker'
  end
end
