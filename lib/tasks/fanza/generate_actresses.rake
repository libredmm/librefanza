require "open-uri"

namespace :fanza do
  desc "Generate fanza actresses"
  task :generate_actresses => :environment do
    Fanza::Api.actress_search do |json|
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
