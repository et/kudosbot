require 'dotenv/load'
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

class KudosService
  include Capybara::DSL

  def initialize
    # Capybara.default_driver = :selenium_chrome_headless
    Capybara.default_driver = :selenium_chrome

    email = ENV['STRAVA_EMAIL']
    password = ENV['STRAVA_PASSWORD']

    raise 'Missing STRAVA_EMAIL' unless email
    raise 'Missing STRAVA_PASSWORD' unless password

    @email = email
    @password = password
  end

  def kudos
    visit 'http://strava.com/login'
    find('#email').set(@email)
    find('#password').set(@password)
    click_button('Log In')

    find('#dashboard-feed') # waits until this dom element is available

    buttons = page.evaluate_script("jQuery('button.js-add-kudo').length")
    p buttons
  end
end