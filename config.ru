require './app'
run Rack::URLMap.new('/' => App.new, '/sidekiq' => Sidekiq::Web)