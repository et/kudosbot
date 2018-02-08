require 'sinatra/base'
require 'sinatra/namespace'

module KudosBot
  module Routes
    module Strava
      def self.registered(app)
        app.register Sinatra::Namespace

        app.namespace '/strava' do
          get '/list-subscriptions' do
            subscriptions = StravaAPIClient.new.list_subscriptions
            content_type :json
            subscriptions.to_json
          end

          post '/create-subscription' do
            callback_url = params['callback_url']
            response = StravaAPIClient.new.create_subscription(callback_url)
          end
        end
      end
    end
  end

  Sinatra.register Routes
end