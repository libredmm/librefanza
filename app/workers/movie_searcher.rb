class MovieSearcher
  include Sidekiq::Worker

  sidekiq_options(
    queue: :default,
    retry: true,
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
      FanzaItemCrawler.perform_async keyword
      return
    end

    found = search_on_fanza(keyword) || search_on_mgstage(keyword)
    unless found
      logger.info "#{keyword} not found anywhere, schedule for javlibrary scrape"
      JavlibraryScraper.perform_async keyword
    end
  end

  def search_on_fanza(keyword)
    logger.info "Searching #{keyword} on Fanza"
    Fanza::Api.search(keyword) do |json|
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
    return if ENV["SKIP_JAVLIBRARY"]

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
