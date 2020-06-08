class FanzaItemCrawler
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(start_date, end_date)
    logger.info "Crawling Fanza from #{start_date} to #{end_date}"
    Fanza::Api.search(start_date: start_date, end_date: end_date, sort: "date") do |json|
      FanzaItem.create(raw_json: json)
    end
  end
end
