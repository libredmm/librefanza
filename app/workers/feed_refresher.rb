class FeedRefresher
  include Sidekiq::Worker

  sidekiq_options(
    queue: :critical,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(interval = 30, max_failures = 3)
    fail_cnt = 0
    Feed.order(updated_at: :asc).each do |feed|
      begin
        feed.refresh!
      rescue ActiveRecord::RecordInvalid => e
        fail_cnt += 1
      end
      break if fail_cnt >= max_failures
      sleep interval
    end
  end
end
