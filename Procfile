web: bundle exec puma --config config/puma.rb -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -r ./lib/workers/kudos_worker.rb -C ./config/sidekiq.yml
