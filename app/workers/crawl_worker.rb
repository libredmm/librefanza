class CrawlWorker
  include Sidekiq::Worker

  sidekiq_options queue: :low, retry: false, lock: :until_executed, on_conflict: :reject

  def perform(keyword)
    logger.info "Crawling #{keyword} on Fanza"
    Fanza::Api.item_list(keyword, sort: "date") do |json|
      FanzaItem.create(
        raw_json: json,
      )
    end
  end
end
