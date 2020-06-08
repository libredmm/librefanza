class HouseKeeper
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(task)
    case task.to_sym
    when :derive_fields
      logger.info "Re-deriving fields"
      Movie.find_each(batch_size: 100, &:derive_fields!)
      FanzaItem.find_each(batch_size: 100, &:derive_fields!)
      MgstageItem.find_each(batch_size: 100, &:derive_fields!)
      JavlibraryItem.find_each(batch_size: 100, &:derive_fields!)
    else
      logger.warn "Invalid task #{task}"
    end
  end
end
