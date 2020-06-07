class FanzaItemCrawler
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_expired,
    lock_ttl: 1.day.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    logger.info "Crawling #{keyword} on Fanza"
    failure_in_a_row = 0
    Fanza::Api.search(keyword: keyword, sort: "date") do |json|
      item = FanzaItem.create(
        raw_json: json,
      )
      if item.persisted?
        failure_in_a_row = 0
      else
        failure_in_a_row += 1
        if failure_in_a_row >= 10
          logger.info "#{keyword}: #{failure_in_a_row} duplicates in a row, aborting crawler."
          break
        end
      end
    end
  end
end
