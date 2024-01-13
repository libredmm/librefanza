require "open-uri"

namespace :mgstage do
  desc "Crawl mgstage pages"
  task :crawl_pages, %i[series] => :environment do |_, args|
    if args.has_key?(:series)
      puts MgstageCrawler.perform_async(args[:series])
    else
      ENV.fetch("MGSTAGE_CRAWL_LIST", "").split.each do |series|
        puts MgstageCrawler.perform_async(series)
      end
    end
  end
end
