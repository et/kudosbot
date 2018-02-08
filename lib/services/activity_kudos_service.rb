require_relative './base_kudos_service'

class ActivityKudosService < BaseKudosService
  def kudos(activity_id)
    login
    find('#dashboard-feed') # waits until this dom element is available
    visit "http://strava.com/activities/#{activity_id}"
    find('.show-kudos') # waits until this dom element is available
    page.evaluate_script("jQuery('button.show-kudos').click()")
  end
end
