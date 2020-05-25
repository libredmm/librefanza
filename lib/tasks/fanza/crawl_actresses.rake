require "open-uri"

namespace :fanza do
  desc "Crawl fanza actresses"
  task :crawl_actresses => :environment do
    offset = FanzaActress.count - 100
    offset = 1 if offset < 1
    Fanza::Api.actress_search(offset: offset) do |json|
      actress = FanzaActress.create(raw_json: json)
      unless actress.persisted?
        actress = FanzaActress.find_by(id_fanza: actress.id_fanza)
        actress.raw_json = json
        actress.derive_fields
        actress.save
      end
    end
  end
end
