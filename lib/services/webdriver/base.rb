require 'capybara'
require 'capybara/dsl'
require 'dotenv/load'
require 'selenium-webdriver'


if ENV['SELENIUM_HOST']
  Capybara.register_driver :selenium_chrome_headless do |app|
    browser_options = ::Selenium::WebDriver::Chrome::Options.new
    browser_options.args << '--headless'
    browser_options.args << '--disable-gpu'
    Capybara::Selenium::Driver.new(app, browser: :chrome,
      url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
      options: browser_options)
  end
else
  Capybara.register_driver :selenium_chrome_headless do |app|
    browser_options = ::Selenium::WebDriver::Chrome::Options.new
    browser_options.args << '--headless'
    browser_options.args << '--disable-gpu'
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
  end
end

class BaseWebdriverService
  include Capybara::DSL

  def initialize
    Capybara.default_driver = :selenium_chrome_headless

    email = ENV['STRAVA_EMAIL']
    password = ENV['STRAVA_PASSWORD']

    raise 'Missing STRAVA_EMAIL' unless email
    raise 'Missing STRAVA_PASSWORD' unless password

    @email = email
    @password = password
  end

  def login
    # sometimes we're still logged in
    return nil if page.has_selector?('#dashboard-feed')

    visit 'http://strava.com/login'
    find('#email').set(@email)
    find('#password').set(@password)
    click_button('Log In')

  rescue Capybara::ElementNotFound => e
    File.open('errors.txt', 'a') do |f|
      f.puts(page.body)
    end
    return nil
  end
end
