desc "Refresh feeds"
task :refresh_feeds, %i[interval max_failures] => :environment do |_, args|
  puts FeedRefresher.perform_async(args[:interval].to_i, args[:max_failures].to_i)
end
