require 'bundler'
require 'rubygems'

Bundler.require

require './app'

run Rack::URLMap.new('/' => KudosBot::App.new, '/sidekiq' => Sidekiq::Web)