require "open-uri"

desc "Do some house keeping"
task :house_keep => :environment do
  HouseKeeper.perform_async
end
