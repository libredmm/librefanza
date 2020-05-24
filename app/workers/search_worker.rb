class SearchWorker
  include Sidekiq::Worker

  sidekiq_options(
    queue: :default,
    retry: 3,
    lock: :until_expired,
    lock_ttl: 1.day.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    logger.info "Searching #{keyword} on Fanza"
    Fanza::Api.item_list(keyword) do |json|
      FanzaItem.create(
        raw_json: json,
      )
    end

    if FanzaItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} found on Fanza"
      return
    end
    logger.info "#{keyword} not found on Fanza"

    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} alreay found on Javlibrary"
      return
    end
    logger.info "Searching #{keyword} on Javlibrary"

    Javlibrary::Api.search(keyword) do |url, raw_html|
      JavlibraryPage.create(url: url, raw_html: raw_html)
    end

    if JavlibraryItem.where(normalized_id: keyword).exists?
      # :nocov:
      logger.info "#{keyword} found on Javlibrary"
      # :nocov:
    else
      logger.warn "#{keyword} not found anywhere"
    end
  end
end
