require_relative './base_kudos_service'

class ActivityKudosService < BaseKudosService
  def kudos(activity_id)
    login
    find('#dashboard-feed')
    visit "http://strava.com/activities/#{activity_id}"
    find('.give-kudos')
    page.evaluate_script("jQuery('.give-kudos span.button:first').click()")
  end
end
