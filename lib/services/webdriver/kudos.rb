require_relative './base'

class KudosWebdriverService < BaseWebdriverService
  def kudos_dashboard
    login
    find('#dashboard-feed') # waits until this dom element is available
    page.evaluate_script("jQuery('button.js-add-kudo').click()")
  rescue Capybara::ElementNotFound => e
    p page.html
    raise e
  end

  def kudos_activity(activity_id)
    login
    find('#dashboard-feed')
    visit "http://strava.com/activities/#{activity_id}"
    find('.give-kudos')
    page.evaluate_script("jQuery('.give-kudos span.button:first').click()")
  end
end
