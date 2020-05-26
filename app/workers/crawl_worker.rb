class CrawlWorker
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_executed,
    on_conflict: :log,
  )

  def perform(keyword)
    logger.info "Crawling #{keyword} on Fanza"
    failure_in_a_row = 0
    Fanza::Api.item_list(keyword, sort: "date") do |json|
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
