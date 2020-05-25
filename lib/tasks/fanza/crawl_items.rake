require "open-uri"

namespace :fanza do
  desc "Crawl fanza items"
  task :crawl_items => :environment do
    FanzaItem.distinct.pluck(:normalized_id).map { |id|
      id.split("-").first
    }.sort.uniq.each { |prefix|
      CrawlWorker.perform_async(prefix)
    }
  end
end
