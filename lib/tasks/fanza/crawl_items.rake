require "open-uri"

namespace :fanza do
  desc "Crawl items from fanza for all known prefix"
  task :crawl_items => :environment do
    FanzaItem.distinct.pluck(:normalized_id).map { |id|
      id.split("-").first
    }.sort.uniq.each { |prefix|
      SearchWorker.perform_async(prefix, false)
    }
  end
end
