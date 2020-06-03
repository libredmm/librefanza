web: bundle exec rails server -p $PORT
sidekiq: bundle exec sidekiq -t 25 -q critical -q default -q low