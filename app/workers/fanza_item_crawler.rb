class FanzaItemCrawler
  include Sidekiq::Worker

  sidekiq_options(
    queue: :critical,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(days_to_crawl = 3)
    1.upto(days_to_crawl) do |i|
      start_date = i.days.ago.to_date
      end_date = (i - 1).days.ago.to_date
      logger.info "Crawling Fanza from #{start_date} to #{end_date}"
      Fanza::Api.search(start_date: start_date, end_date: end_date, sort: "date") do |json|
        FanzaItem.create(raw_json: json)
      end
    end
  end
end
