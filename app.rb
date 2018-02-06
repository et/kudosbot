# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'

require_relative 'lib/services/kudos_service.rb'
require_relative 'lib/workers/kudos_worker.rb'

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

$redis = Redis.new(url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}")

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    stats = Sidekiq::Stats.new
    workers = Sidekiq::Workers.new
    "
    <p>Processed: #{stats.processed}</p>
    <p>In Progress: #{workers.size}</p>
    <p>Enqueued: #{stats.enqueued}</p>
    <p><a href='/'>Refresh</a></p>
    <p><a href='/process_kudos_queue'>Process Kudos Queue</a></p>
    <p><a href='/process_kudos_queue_without_sidekiq'>Process Kudos Queue without sidekiq</a></p>
    <p><a href='/sidekiq'>Dashboard</a></p>
    "
  end

  get '/process_kudos_queue' do
    "
    <p>Processing kudos queue: #{KudosWorker.perform_async}</p>
    <p><a href='/'>Back</a></p>
    "
  end

  get '/process_kudos_queue_without_sidekiq' do
    "
    <p>Processing kudos queue: #{KudosService.new.kudos}</p>
    <p><a href='/'>Back</a></p>
    "
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

    # append the payload to a file
    File.open('events.txt', 'a') do |f|
      f.puts(request_payload)
    end
  end
end
