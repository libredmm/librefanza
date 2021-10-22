web: bundle exec rails server -p $PORT
sidekiq: RAILS_MAX_THREADS=${SIDEKIQ_RAILS_MAX_THREADS:-10} bundle exec sidekiq -t 25