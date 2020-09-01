class MovieSearcher
  include Sidekiq::Worker

  sidekiq_options(
    queue: :default,
    lock: :until_expired,
    lock_ttl: 1.hour.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    unless keyword =~ /^[[:ascii:]]+$/
      logger.info "#{keyword} not searchable, ignored"
      return
    end

    if keyword =~ Regexp.new(ENV.fetch("BLACKHOLE_PATTERN", "^$"), Regexp::IGNORECASE)
      logger.info "#{keyword} blackholed"
      return
    end

    keyword = Fanza::Id.normalize keyword
    unless Fanza::Id.normalized? keyword
      logger.info "#{keyword} is not normalized"
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
    Fanza::Api.search(keyword: keyword) do |json|
      item = FanzaItem.create(raw_json: json)
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
    end

    if MgstageItem.where(normalized_id: keyword).exists?
      logger.info "#{keyword} found on Mgstage"
      true
    else
      logger.info "#{keyword} not found on Mgstage"
      false
    end
  end
end
