# frozen_string_literal: true

require 'dotenv/load'
require 'watir'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end


class KudosWorker
  include Sidekiq::Worker

  def perform
    p 'great job'
    # email = ENV['STRAVA_EMAIL']
    # password = ENV['STRAVA_PASSWORD']

    # raise 'Missing STRAVA_EMAIL' unless email
    # raise 'Missing STRAVA_PASSWORD' unless password

    # run(email, password)
  end

  def run(email, password)
    browser = Watir::Browser.start 'https://www.strava.com/login'

    browser.text_field(:id, 'email').set email
    browser.text_field(:id, 'password').set password
    browser.button(:id, 'login-button').click
    browser.title

    browser.button(class: 'js-add-kudo').wait_until_present
    browser.execute_script("jQuery('button.js-add-kudo').click();")

    browser.close
  end
end
