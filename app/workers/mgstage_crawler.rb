require "open-uri"

class MgstageCrawler
  include Sidekiq::Worker

  sidekiq_options(
    queue: :critical,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform
    Faraday.get(ENV["MGSTAGE_SERIES_URL"]).body.split.each do |series|
      logger.info "[MGS] crawling #{series}"
      Mgstage::Api.search_raw(series.upcase) do |url|
        self.crawl_page url
      end
    end
  end

  private

  def crawl_page(url)
    return if MgstagePage.exists? url: url
    resp = Mgstage::Api.get url
    return unless resp.status == 200
    logger.info "[MGSTAGE] [CRAWLED] #{url}"
    MgstagePage.create(url: url, raw_html: resp.body)
  end
end
