class HouseKeeper
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(task)
    case task.to_sym
    when :fetch_html
      logger.info "Fetching missing raw HTMLs"
      FanzaItem.where(raw_html: "").find_each(&:fetch_html!)
      FanzaItem.where(raw_html: nil).find_each(&:fetch_html!)
    when :derive_fields
      logger.info "Re-deriving fields"
      FanzaItem.find_each(&:derive_fields!)
      MgstageItem.find_each(&:derive_fields!)
      JavlibraryItem.find_each(&:derive_fields!)
    else
      logger.warn "Invalid task #{task}"
    end
  end
end
