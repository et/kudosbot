# frozen_string_literal: true

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/reloader' if development?
require 'dotenv/load'
require 'json'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'

require_relative 'lib/services/activity_kudos_service.rb'
require_relative 'lib/services/dashboard_kudos_service.rb'
require_relative 'lib/workers'
require_relative 'lib/strava_api_client.rb'


Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

$redis = Redis.new(url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}")

module KudosBot
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

    get '/process_kudos_dashboard' do
      "
      <p>Processing kudos queue: #{DashboardKudosWorker.perform_async}</p>
      <p><a href='/'>Back</a></p>
      "
    end

    get '/process_kudos_dashboard_without_sidekiq' do
      "
      <p>Processing kudos queue: #{DashboardKudosService.new.kudos}</p>
      <p><a href='/'>Back</a></p>
      "
    end

    get '/start-kudos-dashboard-worker-cron-job' do
      job = Sidekiq::Cron::Job.new(name: 'Dashboard Kudos Worker - every 10min', cron: '*/10 * * * *', class: 'DashboardKudosWorker')
      if job.save
        job.to_json
      else
        job.errors.to_json
      end
    end

    namespace '/strava' do
      get '/list-subscriptions' do
        subscriptions = StravaAPIClient.new.list_subscriptions
        content_type :json
        subscriptions.to_json
      end

      post '/create-subscription' do
        callback_url = params['callback_url']
        response = StravaAPIClient.new.create_subscription(callback_url)
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