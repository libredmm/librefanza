class JavlibraryScraper
  include Sidekiq::Worker

  sidekiq_options(
    queue: :sidecar,
    lock: :until_expired,
    lock_ttl: 1.day.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    keyword = Fanza::Id.normalize keyword

    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "[JAVLIBRARY] [ALREADY_FOUND] #{keyword}"
      return true
    end
    logger.info "[JAVLIBRARY] [SEARCHING] #{keyword}"

    Javlibrary::Api.search(keyword) do |url, raw_html|
      page = JavlibraryPage.find_or_initialize_by(url: url)
      page.raw_html = raw_html
      page.save!
      break if page.javlibrary_item&.normalized_id == keyword
    end

    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "[JAVLIBRARY] [FOUND] #{keyword}"
      true
    else
      logger.info "[JAVLIBRARY] [NOT_FOUND] #{keyword}"
      false
    end
  end
end
