require 'dotenv/load'
require 'httparty'
require 'logger'

class StravaAPIClient
  include HTTParty

  logger ::Logger.new(STDOUT)
  debug_output
  base_uri 'https://api.strava.com/api/v3'

  def initialize
    client_id = ENV['STRAVA_CLIENT_ID']
    client_secret = ENV['STRAVA_CLIENT_SECRET']
    @options = {
      query: {
        client_id: client_id,
        client_secret: client_secret
      }
    }
  end

  def list_subscriptions
    self.class.get('/push_subscriptions', @options)
  end

  def create_subscription(callback_url)
    post_options = @options
    post_options[:query][:callback_url] = callback_url
    post_options[:query][:verify_token] = 'STRAVA'

    p post_options
    self.class.post("/push_subscriptions", post_options)
  end

  def delete_subscription(subscription_id)
    self.class.delete("/push_subscriptions/#{subscription_id}", @options)
  end
end
