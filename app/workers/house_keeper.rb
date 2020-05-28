class HouseKeeper
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_executed,
    on_conflict: :log,
  )

  def perform()
    logger.info "Fetching raw HTMLs for Fanza Items"
    FanzaItem.find_each(&:fetch_html!)
  end
end
