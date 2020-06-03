class JavlibraryScraper
  include Sidekiq::Worker

  sidekiq_options(
    queue: :macos,
    retry: false,
    lock: :until_expired,
    lock_ttl: 1.day.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    keyword = Fanza::Id.normalize keyword

    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} alreay found on Javlibrary"
      return true
    end
    logger.info "Searching #{keyword} on Javlibrary"

    Javlibrary::Api.search(keyword) do |url, raw_html|
      page = JavlibraryPage.find_or_initialize_by(url: url)
      page.raw_html = raw_html
      page.save
      logger.error(page.errors.full_messages) unless page.persisted?
      break if page.javlibrary_item&.normalized_id == keyword
    end

    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} found on Javlibrary"
      true
    else
      logger.info "#{keyword} not found on Javlibrary"
      false
    end
  end
end
