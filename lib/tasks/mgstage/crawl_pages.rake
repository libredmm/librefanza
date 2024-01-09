require "open-uri"

namespace :mgstage do
  desc "Crawl mgstage pages"
  task :crawl_pages, %i[series min max] => :environment do |_, args|
    puts MgstageCrawler.perform_async(
      args[:series],
      args[:min].to_i,
      args[:max].to_i,
    )
  end
end
