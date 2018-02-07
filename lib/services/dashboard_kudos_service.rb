require_relative './base_kudos_service'

class DashboardKudosService < BaseKudosService
  def kudos
    login
    find('#dashboard-feed') # waits until this dom element is available
    page.evaluate_script("jQuery('button.js-add-kudo').click()")
  rescue Capybara::ElementNotFound => e
    p page.html
    raise e
  end
end
