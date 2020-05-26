class JavlibraryWorker
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: 3,
    lock: :until_expired,
    lock_ttl: 1.hour.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} alreay found on Javlibrary"
      return
    end
    logger.info "Searching #{keyword} on Javlibrary"

    Javlibrary::Api.search(keyword) do |url, raw_html|
      page = JavlibraryPage.create(url: url, raw_html: raw_html)
      break if page&.javlibrary_item&.normalized_id == keyword
    end

    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} found on Javlibrary"
    else
      logger.info "#{keyword} not found on Javlibrary"
    end
  end
end
