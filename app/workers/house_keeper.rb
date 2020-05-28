class HouseKeeper
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform()
    logger.info "Fetching raw HTMLs for Fanza Items"
    FanzaItem.where(raw_html: "").find_each(&:fetch_html!)
    FanzaItem.where(raw_html: nil).find_each(&:fetch_html!)
  end
end
