class FanzaItemCrawler
  include Sidekiq::Worker

  sidekiq_options(
    queue: :critical,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform
    1.week.ago.to_date.upto(Date.today) do |date|
      start_date = date.strftime("%Y-%m-%dT%H:%M:%S"),
      end_date = (date + 1.day).strftime("%Y-%m-%dT%H:%M:%S")
      logger.info "Crawling Fanza from #{start_date} to #{end_date}"
      Fanza::Api.search(start_date: start_date, end_date: end_date, sort: "date") do |json|
        FanzaItem.create(raw_json: json)
      end
    end
  end
end
