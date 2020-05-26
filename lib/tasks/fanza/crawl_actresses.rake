require "open-uri"

namespace :fanza do
  desc "Crawl fanza actresses"
  task :crawl_actresses => :environment do
    ActressWorker.perform_async(1000)
  end
end
