class ActressWorker
  include Sidekiq::Worker

  sidekiq_options(
    queue: :critical,
    retry: 3,
    lock: :until_executed,
    on_conflict: :log,
  )

  def perform(overlap)
    offset = FanzaActress.count - overlap + 1
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
