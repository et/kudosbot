require 'watir'
require "kudosbot/version"

module Kudosbot
  def run(email, password)
   browser = Watir::Browser.new :chrome
   browser.goto "https://www.strava.com/login"

   browser.text_field(:id, 'email').set email
   browser.text_field(:id, 'password').set password
   browser.button(:id, 'login-button').click
   browser.title

   browser.button(class: "js-add-kudo").wait_until_present
   browser.execute_script("jQuery('button.js-add-kudo').click();")
  end
end