# frozen_string_literal: true

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/reloader' if development?
require 'dotenv/load'
require 'json'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require 'sidekiq-scheduler/web'


Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

$redis = Redis.new(url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}")

module KudosBot
  require_relative './lib/services'
  require_relative './lib/workers'

  class App < Sinatra::Base
    register Sinatra::Namespace

    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      stats = Sidekiq::Stats.new
      workers = Sidekiq::Workers.new
      erb :index, locals: { stats: stats, workers: workers }
    end

    get '/process-kudos-dashboard' do
      "
      <p>Processing kudos queue: #{DashboardKudosWorker.perform_async}</p>
      <p><a href='/'>Back</a></p>
      "
    end

    get '/process-kudos-dashboard-without-sidekiq' do
      "
      <p>Processing kudos queue: #{KudosService.new.kudos_dashboard}</p>
      <p><a href='/'>Back</a></p>
      "
    end

    namespace '/strava' do

      get '/list-subscriptions' do
        subscriptions = SubscriptionApiService.new.list_subscriptions
        content_type :json
        subscriptions.to_json
      end

      post '/create-subscription' do
        callback_url = params['callback_url']
        response = SubscriptionApiService.new.create_subscription(callback_url)
        response.to_json
      end

      get '/event' do
        hub_challenge = params['hub.challenge']
        p hub_challenge

        content_type :json
        { 'hub.challenge': hub_challenge }.to_json
      end

      post '/event' do
        status 200
        request.body.rewind
        request_payload = JSON.parse(request.body.read)
        p request_payload

        if request_payload['aspect_type'] == 'create'
          ActivityKudosWorker.perform_async(request_payload['object_id'])
        end

        # append the payload to a file
        File.open('events.txt', 'a') do |f|
          f.puts(request_payload)
        end
      end
    end
  end
end