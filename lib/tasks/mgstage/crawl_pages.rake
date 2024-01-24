require "open-uri"

namespace :mgstage do
  desc "Crawl mgstage pages"
  task :crawl_pages, %i[series] => :environment do |_, args|
    if args.has_key?(:series)
      puts MgstageCrawler.perform_async(args[:series])
    else
      URI.parse("https://s3.junz.info/data/av_mgstage_data").read.split.each do |series|
        puts "#{series}: #{MgstageCrawler.perform_async(series)}"
      end
    end
  end
end
