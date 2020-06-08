require "open-uri"

namespace :fanza do
  desc "Crawl fanza items"
  task :crawl_items, %i[start_date end_date] => :environment do |_, args|
    start_date = args[:start_date] ? Date.parse(args[:start_date]) : 1.week.ago.to_date
    end_date = args[:end_date] ? Date.parse(args[:end_date]) : (start_date + 1.week)
    start_date.upto(end_date - 1.day) do |date|
      puts FanzaItemCrawler.perform_async(
        date.strftime("%Y-%m-%dT%H:%M:%S"),
        (date + 1.day).strftime("%Y-%m-%dT%H:%M:%S")
      )
    end
  end
end
