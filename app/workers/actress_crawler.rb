class ActressCrawler
  include Sidekiq::Worker

  sidekiq_options(
    queue: :critical,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(overlap)
    offset = FanzaActress.count - overlap + 1
    offset = 1 if offset < 1
    Fanza::Api.actress_search(offset: offset) do |json|
      actress = FanzaActress.create(raw_json: json)
      unless actress.persisted?
        actress = FanzaActress.find_by(fanza_id: actress.fanza_id)
        actress.raw_json = json
        actress.derive_fields
        actress.save
      end
    end
  end
end
