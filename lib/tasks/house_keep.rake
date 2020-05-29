require "open-uri"

desc "Do some house keeping"
task :house_keep, %i[task] => :environment do |_, args|
  HouseKeeper.perform_async args[:task].to_sym
end
