require "open-uri"

namespace :fanza do
  desc "Generate fanza actresses"
  task :generate_actresses => :environment do
    actresses = Fanza::Api.actress_search
    puts actresses.count
    actresses.each do |actress|
      FanzaActress.create(raw_json: actress)
    end
  end
end
