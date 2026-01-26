class FanzaSearcher
  include Sidekiq::Worker

  sidekiq_options(
    queue: :default,
    lock: :until_executed,
    lock_ttl: 1.hour.to_i,
    lock_args_method: :lock_args,
    on_conflict: :log,
  )

  SEARCH_COOLDOWN = 1.day

  def self.lock_args(args)
    [args[0]]
  end

  def self.searched_keywords
    @searched_keywords ||= {}
  end

  def self.recently_searched?(keyword)
    cleanup_expired_keywords
    searched_at = searched_keywords[keyword]
    return false unless searched_at

    searched_at > SEARCH_COOLDOWN.ago
  end

  def self.mark_searched(keyword)
    searched_keywords[keyword] = Time.current
  end

  def self.cleanup_expired_keywords
    cutoff = SEARCH_COOLDOWN.ago
    searched_keywords.delete_if { |_, searched_at| searched_at <= cutoff }
  end

  def self.clear_searched_keywords
    @searched_keywords = {}
  end

  def perform(keyword, options = {})
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

    force = options.symbolize_keys[:force] || false

    unless force
      if self.class.recently_searched?(id.normalized)
        logger.info "[RECENTLY_SEARCHED] #{id.normalized}"
        return
      end
    end

    found = search_on_fanza(id.normalized, force: force) ||
            search_on_mgstage(id.normalized) ||
            search_on_fc2(id.normalized)

    self.class.mark_searched(id.normalized)
  end

  def search_on_fanza(keyword, force: false)
    logger.info "[FANZA] [SEARCHING] #{keyword}"
    Fanza::Api.search(keyword: keyword) do |json|
      content_id = json["content_id"]&.strip
      if force && content_id
        item = FanzaItem.find_or_initialize_by(content_id: content_id)
        item.raw_json = json
        logger.info "[FANZA] [UPDATING] #{content_id}: #{json}"
        item.save
      else
        FanzaItem.create(raw_json: json)
      end
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

  def search_on_fc2(keyword)
    if Fc2Item.where(normalized_id: keyword).exists?
      logger.info "[FC2] [ALREADY_FOUND] #{keyword}"
      return true
    end
    logger.info "[FC2] [SEARCHING] #{keyword}"

    Fc2::Api.search(keyword) do |url, raw_html|
      page = Fc2Page.create(url: url, raw_html: raw_html)
    end

    if Fc2Item.where(normalized_id: keyword).exists?
      logger.info "[FC2] [FOUND] #{keyword}"
      true
    else
      logger.info "[FC2] [NOT_FOUND] #{keyword}"
      false
    end
  end
end
