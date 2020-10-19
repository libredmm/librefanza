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
      logger.info "[NON_ASCII] #{keyword}"
      return
    end

    if keyword =~ Regexp.new(ENV.fetch("BLACKHOLE_PATTERN", "^$"), Regexp::IGNORECASE)
      logger.info "[BLACKHOLED] #{keyword}"
      return
    end

    keyword = Fanza::Id.normalize keyword
    unless Fanza::Id.normalized? keyword
      logger.info "[UNNORMALIZED] #{keyword}"
      return
    end

    found = search_on_fanza(keyword) || search_on_mgstage(keyword)
    unless found
      JavlibraryScraper.perform_async keyword
    end
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
end
