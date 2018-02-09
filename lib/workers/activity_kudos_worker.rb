# frozen_string_literal: true

require 'sidekiq-scheduler'
require_relative '../services/activity_kudos_service.rb'

class ActivityKudosWorker
  include Sidekiq::Worker

  def perform(object_id)
    p 'Starting activity kudos worker'
    ActivityKudosService.new.kudos(object_id)
    p 'Ending activity kudos worker'
  end
end
