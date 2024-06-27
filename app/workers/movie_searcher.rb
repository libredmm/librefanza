class MovieSearcher
  include Sidekiq::Worker

  sidekiq_options(
    queue: :default,
    lock: :until_expired,
    lock_ttl: 1.day.to_i,
    on_conflict: :log,
  )

  def perform(keyword)
    unless keyword =~ /^[[:ascii:]]+$/
      logger.info "[NON_ASCII] #{keyword}"
      return
    end

    if keyword =~ Regexp.new(ENV.fetch("BLACKHOLE_PATTERN", "^$"), Regexp::IGNORECASE)
      logger.info "[BLACKHOLED] #{keyword}"
      return
    end

    id = Fanza::Id.new(keyword)
    unless id.normalized
      logger.info "[UNNORMALIZED] #{keyword}"
      return
    end

    found = search_on_fanza(id.normalized) || search_on_mgstage(id.normalized) || search_on_javlibrary(id.normalized)
  end

  def search_on_fanza(keyword)
    logger.info "[FANZA] [SEARCHING] #{keyword}"
    Fanza::Api.search(keyword: keyword) do |json|
      item = FanzaItem.create(raw_json: json)
    end

    if FanzaItem.where(normalized_id: keyword).exists?
      logger.info "[FANZA] [FOUND] #{keyword}"
      true
    else
      logger.info "[FANZA] [NOT_FOUND] #{keyword}"
      false
    end
  end

  def search_on_mgstage(keyword)
    if MgstageItem.where(normalized_id: keyword).exists?
      logger.info "[MGSTAGE] [ALREADY_FOUND] #{keyword}"
      return true
    end
    logger.info "[MGSTAGE] [SEARCHING] #{keyword}"

    Mgstage::Api.search(keyword) do |url, raw_html|
      page = MgstagePage.create(url: url, raw_html: raw_html)
    end

    if MgstageItem.where(normalized_id: keyword).exists?
      logger.info "[MGSTAGE] [FOUND] #{keyword}"
      true
    else
      logger.info "[MGSTAGE] [NOT_FOUND] #{keyword}"
      false
    end
  end

  def search_on_javlibrary(keyword)
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
