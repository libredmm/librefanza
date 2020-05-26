class JavlibraryWorker
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_executed,
    on_conflict: :reject,
  )

  @@semaphore = Mutex.new

  def perform(keyword)
    @@semaphore.synchronize do
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
end
