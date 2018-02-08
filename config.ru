require 'bundler'
require 'rubygems'

Bundler.require

require './app'
require 'sidekiq/web'
require 'sidekiq/cron/web'

run Rack::URLMap.new('/' => KudosBot::App.new, '/sidekiq' => Sidekiq::Web)