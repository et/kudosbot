require 'bundler'
require 'rubygems'

Bundler.require

require './app'

run KudosBot::App.new

#run Rack::URLMap.new('/' => KudosBot::App.new, '/sidekiq' => Sidekiq::Web)

#run Rack::URLMap.new('/' => KudosBot::App.new, '/sidekiq' => Sidekiq::Web)