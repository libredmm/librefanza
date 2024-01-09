require "open-uri"

namespace :mgstage do
  desc "Crawl mgstage pages"
  task :crawl_pages, %i[series] => :environment do |_, args|
    puts MgstageCrawler.perform_async(args[:series])
  end
end
