class SearchWorker
  include Sidekiq::Worker

  sidekiq_options(
    queue: :default,
    retry: false,
    lock: :until_expired,
    lock_ttl: 1.hour.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    unless keyword =~ /^[[:ascii:]]+$/
      logger.info "#{keyword} not searchable, ignored"
      return
    end

    keyword = Fanza::Id.normalize keyword
    unless Fanza::Id.normalized? keyword
      logger.info "#{keyword} is not normalized, try crawl instead of search"
      CrawlWorker.perform_async keyword
      return
    end

    found = search_on_fanza(keyword) || search_on_mgstage(keyword) || search_on_javlibrary(keyword)
    logger.warn "#{keyword} not found anywhere" unless found
  end

  def search_on_fanza(keyword)
    logger.info "Searching #{keyword} on Fanza"
    Fanza::Api.item_list(keyword) do |json|
      item = FanzaItem.create(
        raw_json: json,
      )
      break if item.normalized_id == keyword
    end

    if FanzaItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} found on Fanza"
      true
    else
      logger.info "#{keyword} not found on Fanza"
      false
    end
  end

  def search_on_mgstage(keyword)
    if MgstageItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} alreay found on Mgstage"
      return true
    end
    logger.info "Searching #{keyword} on Mgstage"

    Mgstage::Api.search(keyword) do |url, raw_html|
      page = MgstagePage.create(url: url, raw_html: raw_html)
      break if page&.mgstage_item&.normalized_id == keyword
    end

    if MgstageItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} found on Mgstage"
      true
    else
      logger.info "#{keyword} not found on Mgstage"
      false
    end
  end

  def search_on_javlibrary(keyword)
    if JavlibraryItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} alreay found on Javlibrary"
      return true
    end
    logger.info "Searching #{keyword} on Javlibrary"

    Javlibrary::Api.search(keyword) do |url, raw_html|
      page = JavlibraryPage.create(url: url, raw_html: raw_html)
      break if page&.javlibrary_item&.normalized_id == keyword
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
