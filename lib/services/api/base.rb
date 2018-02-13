require 'dotenv/load'
require 'httparty'

class BaseApiService
  include HTTParty

  logger ::Logger.new(STDOUT)
  debug_output
  base_uri 'https://www.strava.com/api/v3'

  def initialize
    token = ENV['STRAVA_ACCESS_TOKEN']
    @options = {
      headers: {
        AUTHORIZATION: "Bearer #{token}"
      }
    }
  end
end