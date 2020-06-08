require "open-uri"

namespace :fanza do
  desc "Crawl fanza items"
  task :crawl_items, %i[start_date end_date] => :environment do |_, args|
    start_date = args[:start_date] ? Time.zone.parse(args[:start_date]) : 3.days.ago.beginning_of_day
    end_date = args[:end_date] ? Time.zone.parse(args[:end_date]) : start_date + 1.week
    FanzaItemCrawler.perform_async(
      start_date.strftime("%Y-%m-%dT%H:%M:%S"),
      end_date.strftime("%Y-%m-%dT%H:%M:%S")
    )
  end
end
