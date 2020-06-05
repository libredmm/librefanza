require "open-uri"

desc "Fill some gaps"
task :fill_gap, %i[prefix] => :environment do |_, args|
  puts GapFiller.perform_async(args[:prefix].to_sym)
end
